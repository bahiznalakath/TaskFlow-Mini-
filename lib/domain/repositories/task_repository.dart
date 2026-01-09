import '../entities/task.dart';
import '../entities/subtask.dart';



abstract class TaskRepository {
  Future<List<Task>> fetchTasks(String projectId);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> assignUsers(String taskId, List<String> users);

  Future<List<Subtask>> fetchSubtasks(String taskId);
  Future<void> createSubtask(Subtask subtask);
  Future<void> updateSubtask(Subtask subtask);
}

