import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'router/app_router.dart';

// Hive models
import 'data/models/project_hive.dart';
import 'data/models/task_hive.dart';
import 'data/models/subtask_hive.dart';
import 'data/models/user_hive.dart';

// Auth
import 'core/auth/seed_users.dart';

// Repository implementations
import 'data/repositories/project_repository_impl.dart'
as project_repo;
import 'data/repositories/task_repository_impl.dart'
as task_repo;
import 'data/repositories/report_repository_impl.dart'
as report_repo;

// BLoCs
import 'presentation/blocs/project/project_bloc.dart';
import 'presentation/blocs/project/project_event.dart';
import 'presentation/blocs/task/task_bloc.dart';
import 'presentation/blocs/report/report_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -------- HIVE INIT --------
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ProjectHiveAdapter());
  Hive.registerAdapter(TaskHiveAdapter());
  Hive.registerAdapter(SubtaskHiveAdapter());
  Hive.registerAdapter(UserHiveAdapter());

  // -------- OPEN ALL REQUIRED BOXES --------
  await Hive.openBox<ProjectHive>('projects');
  await Hive.openBox<TaskHive>('tasks');
  await Hive.openBox<SubtaskHive>('subtasks');
  await Hive.openBox<UserHive>('users');
  await Hive.openBox('session');

  // -------- SEED USERS (ONLY ONCE) --------
  await seedUsers();

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            // -------- PROJECT BLOC --------
            BlocProvider(
              create: (_) {
                final projectRepo =
                project_repo.ProjectRepositoryImpl();
                return ProjectBloc(projectRepo)
                  ..add(LoadProjects());
              },
            ),

            // -------- TASK BLOC --------
            BlocProvider(
              create: (_) {
                final taskRepo =
                task_repo.TaskRepositoryImpl();
                return TaskBloc(taskRepo);
              },
            ),

            // -------- REPORT BLOC --------
            BlocProvider(
              create: (_) {
                final reportRepo =
                report_repo.ReportRepositoryImpl();
                return ReportBloc(reportRepo);
              },
            ),
          ],

          // -------- THEME TOGGLE SUPPORT --------
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode, // 🔥 TOGGLE WORKS
                routerConfig: appRouter,
              );
            },
          ),
        );
      },
    );
  }
}
