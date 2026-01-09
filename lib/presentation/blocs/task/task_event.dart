import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/entities/subtask.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String projectId;
  const LoadTasks(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class CreateTask extends TaskEvent {
  final Task task;
  const CreateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class AssignUsers extends TaskEvent {
  final String taskId;
  final List<String> users;
  const AssignUsers(this.taskId, this.users);

  @override
  List<Object?> get props => [taskId, users];
}

class LoadSubtasks extends TaskEvent {
  final String taskId;
  const LoadSubtasks(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CreateSubtask extends TaskEvent {
  final Subtask subtask;
  const CreateSubtask(this.subtask);

  @override
  List<Object?> get props => [subtask];
}

class UpdateSubtask extends TaskEvent {
  final Subtask subtask;
  const UpdateSubtask(this.subtask);

  @override
  List<Object?> get props => [subtask];
}
