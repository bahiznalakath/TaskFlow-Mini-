import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/subtask.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  const TaskDetailsPage({super.key, required this.taskId});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController _timeSpentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load subtasks ONCE
    context.read<TaskBloc>().add(LoadSubtasks(widget.taskId));
  }

  @override
  void dispose() {
    _timeSpentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // ---------- LOADING ----------
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ---------- ERROR ----------
          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          // ---------- LOADED ----------
          if (state is TaskLoaded) {
            final Task task = state.tasks.firstWhere(
                  (t) => t.id == widget.taskId,
            );

            final List<Subtask> subtasks = state.subtasks;

            _timeSpentCtrl.text = task.timeSpent.toString();

            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // -------- TITLE --------
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  task.description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 16.h),

                // -------- STATUS --------
                Text('Status', style: _sectionStyle()),
                DropdownButton<TaskStatus>(
                  value: task.status,
                  isExpanded: true,
                  items: TaskStatus.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      context.read<TaskBloc>().add(
                        UpdateTask(
                          task.copyWith(status: newStatus),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 16.h),

                // -------- TIME SPENT --------
                Text('Time Spent (hrs)', style: _sectionStyle()),
                TextField(
                  controller: _timeSpentCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter hours',
                  ),
                  onSubmitted: (value) {
                    final double hrs =
                        double.tryParse(value) ?? task.timeSpent;

                    context.read<TaskBloc>().add(
                      UpdateTask(
                        task.copyWith(timeSpent: hrs),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // -------- SUBTASK HEADER --------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtasks', style: _sectionStyle()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddSubtaskDialog(context),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // -------- SUBTASK LIST --------
                if (subtasks.isEmpty)
                  const Text('No subtasks')
                else
                  Column(
                    children: subtasks.map((Subtask s) {
                      return CheckboxListTile(
                        value: s.completed,
                        title: Text(
                          s.title,
                          style: TextStyle(
                            decoration: s.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        activeColor: AppColors.primary,
                        onChanged: (_) {
                          context.read<TaskBloc>().add(
                            UpdateSubtask(
                              s.copyWith(
                                completed: !s.completed,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // -------- ADD SUBTASK DIALOG --------
  void _showAddSubtaskDialog(BuildContext context) {
    final TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'Subtask title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;

              final subtask = Subtask(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                taskId: widget.taskId,
                title: ctrl.text.trim(),
                completed: false,
              );

              context.read<TaskBloc>().add(
                CreateSubtask(subtask),
              );

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  TextStyle _sectionStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    );
  }
}
