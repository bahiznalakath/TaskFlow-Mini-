import 'package:go_router/go_router.dart';

import '../core/auth/session_manager.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/project_list_page.dart';
import '../presentation/pages/project_report_page.dart';
import '../presentation/pages/task_details_page.dart';
import '../presentation/pages/task_list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // 🔴 SAFE: session box is already opened in main()
    final userId = SessionManager.getUser();

    final isLoggedIn = userId != null;
    final isLoggingIn = state.uri.toString() == '/login';

    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }

    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const ProjectListPage(),
    ),
    /// Task List by Project
    GoRoute(
      path: '/project/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        return TaskListPage(projectId: projectId);
      },
    ),

    /// Task Details
    GoRoute(
      path: '/task/:taskId',
      builder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return TaskDetailsPage(taskId: taskId);
      },
    ),

    /// Project Report
    GoRoute(
      path: '/report/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        return ProjectReportPage(projectId: projectId);
      },
    ),
  ],
);
