import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/subtask.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_hive.dart';
import '../models/subtask_hive.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<TaskHive> taskBox = Hive.box<TaskHive>('tasks');
  final Box<SubtaskHive> subtaskBox = Hive.box<SubtaskHive>('subtasks');

  @override
  Future<List<Task>> fetchTasks(String projectId) async {
    return taskBox.values
        .where((t) => t.projectId == projectId)
        .map(_mapTask)
        .toList();
  }

  @override
  Future<void> createTask(Task task) async {
    await taskBox.put(
      task.id,
      TaskHive(
        id: task.id,
        projectId: task.projectId,
        title: task.title,
        description: task.description,
        status: task.status.index,
        priority: task.priority.index,
        startDate: task.startDate,
        dueDate: task.dueDate,
        estimate: task.estimate,
        timeSpent: task.timeSpent,
        assignees: task.assignees,
        labels: task.labels,
      ),
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await createTask(task);
  }

  @override
  Future<void> assignUsers(String taskId, List<String> users) async {
    final task = taskBox.get(taskId);
    if (task != null) {
      task.assignees = users;
      await task.save();
    }
  }

  @override
  Future<List<Subtask>> fetchSubtasks(String taskId) async {
    return subtaskBox.values
        .where((s) => s.taskId == taskId)
        .map(_mapSubtask)
        .toList();
  }

  @override
  Future<void> createSubtask(Subtask subtask) async {
    await subtaskBox.put(
      subtask.id,
      SubtaskHive(
        id: subtask.id,
        taskId: subtask.taskId,
        title: subtask.title,
        completed: subtask.completed,
        assignee: subtask.assignee,
      ),
    );
  }

  @override
  Future<void> updateSubtask(Subtask subtask) async {
    await createSubtask(subtask);
  }

  // ---------- MAPPERS ----------
  Task _mapTask(TaskHive h) => Task(
    id: h.id,
    projectId: h.projectId,
    title: h.title,
    description: h.description,
    status: TaskStatus.values[h.status],
    priority: TaskPriority.values[h.priority],
    startDate: h.startDate,
    dueDate: h.dueDate,
    estimate: h.estimate,
    timeSpent: h.timeSpent,
    assignees: h.assignees,
    labels: h.labels,
  );

  Subtask _mapSubtask(SubtaskHive h) => Subtask(
    id: h.id,
    taskId: h.taskId,
    title: h.title,
    completed: h.completed,
    assignee: h.assignee,
  );
}
