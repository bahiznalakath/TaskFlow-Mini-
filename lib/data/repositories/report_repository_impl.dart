import '../../domain/repositories/report_repository.dart';
import '../../presentation/blocs/report/report_state.dart';
import '../../domain/entities/task.dart';
import 'task_repository_impl.dart';

class ReportRepositoryImpl implements ReportRepository {
  final TaskRepositoryImpl _taskRepository = TaskRepositoryImpl();

  @override
  Future<ReportState> projectStatus(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final List<Task> tasks =
    await _taskRepository.fetchTasks(projectId);

    final int total = tasks.length;
    final int done =
        tasks.where((t) => t.status == TaskStatus.done).length;
    final int inProgress =
        tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final int blocked =
        tasks.where((t) => t.status == TaskStatus.blocked).length;

    final int overdue = tasks.where(
          (t) =>
      t.status != TaskStatus.done &&
          t.dueDate.isBefore(DateTime.now()),
    ).length;

    final double completion =
    total == 0 ? 0.0 : (done / total) * 100.0;

    final Map<String, int> openByAssignee = {};

    for (final task in tasks) {
      if (task.status != TaskStatus.done) {
        for (final assignee in task.assignees) {
          openByAssignee[assignee] =
              (openByAssignee[assignee] ?? 0) + 1;
        }
      }
    }

    return ReportState(
      total: total,
      done: done,
      inProgress: inProgress,
      blocked: blocked,
      overdue: overdue,
      completion: completion,
      openByAssignee: openByAssignee,
    );
  }
}
