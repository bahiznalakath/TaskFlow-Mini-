import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../core/auth/session_manager.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

import '../../data/models/user_hive.dart';
import '../../domain/entities/project.dart';
import '../blocs/project/project_bloc.dart';
import '../blocs/project/project_state.dart';
import '../blocs/project/project_event.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdmin = AuthService.isAdmin();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.background
          : AppColors.backgroundLight,

      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          // 🌗 THEME TOGGLE
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),

          // 🚪 LOGOUT
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager.logout();
              context.go('/login');
            },
          ),
        ],
      ),

      // ➕ CREATE PROJECT (ADMIN ONLY)
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => _showCreateProjectDialog(context),
              child: const Icon(Icons.add),
            )
          : null,

      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (_, state) {
          if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProjectError) {
            return Center(child: Text(state.message));
          }

          if (state is ProjectLoaded) {
            if (state.projects.isEmpty) {
              return const Center(child: Text('No projects found'));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.projects.length,
              itemBuilder: (_, i) {
                final project = state.projects[i];
                final isAdmin = AuthService.isAdmin();

                return Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.card : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark ? AppColors.border : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- TITLE + ACTIONS --------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  context.push('/project/${project.id}'),
                              child: Text(
                                project.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ),

                          // ✏️ EDIT (ADMIN)
                          if (isAdmin)
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                              onPressed: () =>
                                  _showEditProjectDialog(context, project),
                            ),

                          // 🗑 DELETE (ADMIN)
                          if (isAdmin)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 18.sp,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _confirmDelete(context, project),
                            ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      // -------- DESCRIPTION --------
                      Text(
                        project.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondaryLight,
                        ),
                      ),

                      // -------- ASSIGNED USER --------
                      if (project.assignedUsers.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Assigned to: ${_userName(project.assignedUsers.first)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ---------------- CREATE PROJECT (ADMIN) ----------------
  void _showCreateProjectDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final usersBox = Hive.box<UserHive>('users');

    // Only employees
    final employees = usersBox.values
        .where((u) => u.role == 'employee')
        .toList();

    String? selectedUserId;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Project'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),

                SizedBox(height: 16.h),

                // 👤 ASSIGN USER (DROPDOWN)
                DropdownButtonFormField<String>(
                  value: selectedUserId,
                  hint: const Text('Assign Employee'),
                  items: employees.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user.email),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUserId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ProjectBloc>().add(
                    CreateProject(
                      Project(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text,
                        description: descCtrl.text,
                        assignedUsers: selectedUserId == null
                            ? []
                            : [selectedUserId!],
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<ProjectBloc>().add(DeleteProject(project.id));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditProjectDialog(BuildContext context, Project project) {
    final nameCtrl = TextEditingController(text: project.name);
    final descCtrl = TextEditingController(text: project.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProjectBloc>().add(
                UpdateProject(
                  project.copyWith(
                    name: nameCtrl.text,
                    description: descCtrl.text,
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ---------------- USER NAME HELPER ----------------
  String _userName(String id) {
    switch (id) {
      case 'u2':
        return 'Staff 1';
      case 'u3':
        return 'Staff 2';
      default:
        return id;
    }
  }
}
