import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/entities/subtask.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(const TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<AssignUsers>(_onAssignUsers);
    on<LoadSubtasks>(_onLoadSubtasks);
    on<CreateSubtask>(_onCreateSubtask); // ✅ FIXED
    on<UpdateSubtask>(_onUpdateSubtask);
  }

  // ---------------- LOAD TASKS ----------------
  Future<void> _onLoadTasks(
      LoadTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(const TaskLoading());
    final tasks = await repository.fetchTasks(event.projectId);
    emit(TaskLoaded(tasks: tasks));
  }

  // ---------------- CREATE TASK ----------------
  Future<void> _onCreateTask(
      CreateTask event,
      Emitter<TaskState> emit,
      ) async {
    await repository.createTask(event.task);
  }

  // ---------------- UPDATE TASK ----------------
  Future<void> _onUpdateTask(
      UpdateTask event,
      Emitter<TaskState> emit,
      ) async {
    await repository.updateTask(event.task);

    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      emit(TaskLoaded(
        tasks: current.tasks.map((t) {
          return t.id == event.task.id ? event.task : t;
        }).toList(),
        subtasks: current.subtasks,
      ));
    }
  }

  // ---------------- ASSIGN USERS ----------------
  Future<void> _onAssignUsers(
      AssignUsers event,
      Emitter<TaskState> emit,
      ) async {
    await repository.assignUsers(event.taskId, event.users);
  }

  // ---------------- LOAD SUBTASKS ----------------
  Future<void> _onLoadSubtasks(
      LoadSubtasks event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      final subtasks = await repository.fetchSubtasks(event.taskId);

      emit(TaskLoaded(
        tasks: current.tasks,
        subtasks: subtasks,
      ));
    }
  }

  // ---------------- CREATE SUBTASK ----------------
  Future<void> _onCreateSubtask(
      CreateSubtask event,
      Emitter<TaskState> emit,
      ) async {
    await repository.createSubtask(event.subtask);

    if (state is TaskLoaded) {
      final current = state as TaskLoaded;

      emit(TaskLoaded(
        tasks: current.tasks,
        subtasks: [...current.subtasks, event.subtask],
      ));
    }
  }

  // ---------------- UPDATE SUBTASK ----------------
  Future<void> _onUpdateSubtask(
      UpdateSubtask event,
      Emitter<TaskState> emit,
      ) async {
    await repository.updateSubtask(event.subtask);

    if (state is TaskLoaded) {
      final current = state as TaskLoaded;

      emit(TaskLoaded(
        tasks: current.tasks,
        subtasks: current.subtasks.map((s) {
          return s.id == event.subtask.id ? event.subtask : s;
        }).toList(),
      ));
    }
  }
}
