import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../core/auth/auth_service.dart';

import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;

  ProjectBloc(this.repository) : super(ProjectLoading()) {
    on<LoadProjects>(_onLoadProjects);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject); // ✅
    on<DeleteProject>(_onDeleteProject); // ✅
    on<ArchiveProject>(_onArchiveProject);
  }

  // ---------------- LOAD PROJECTS ----------------
  Future<void> _onLoadProjects(
      LoadProjects event,
      Emitter<ProjectState> emit,
      ) async {
    emit(ProjectLoading());

    try {
      final user = AuthService.getCurrentUser();
      List<Project> projects = await repository.fetchProjects();

      // 👤 Employee → only assigned projects
      if (user != null && user.role == 'employee') {
        projects = projects
            .where((p) => p.assignedUsers.contains(user.id))
            .toList();
      }

      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(  ProjectError('Failed to load projects'));
    }
  }

  // ---------------- CREATE PROJECT ----------------
  Future<void> _onCreateProject(
      CreateProject event,
      Emitter<ProjectState> emit,
      ) async {
    try {
      await repository.createProject(event.project);
      add(LoadProjects()); // 🔄 Refresh list
    } catch (_) {
      emit(  ProjectError('Failed to create project'));
    }
  }

  // ---------------- ARCHIVE / UNARCHIVE PROJECT ----------------
  Future<void> _onArchiveProject(
      ArchiveProject event,
      Emitter<ProjectState> emit,
      ) async {
    if (!AuthService.isAdmin()) {
      emit(  ProjectError('Only admin can archive projects'));
      return;
    }

    try {
      await repository.archiveProject(
        event.projectId,
        event.isArchived, // ✅ FIXED
      );

      add(LoadProjects());
    } catch (_) {
      emit(  ProjectError('Failed to archive project'));
    }
  }
// ---------------- UPDATE PROJECT ----------------
  Future<void> _onUpdateProject(
      UpdateProject event,
      Emitter<ProjectState> emit,
      ) async {
    try {
      await repository.updateProject(event.project);
      add(LoadProjects());
    } catch (_) {
      emit(  ProjectError('Failed to update project'));
    }
  }

// ---------------- DELETE PROJECT ----------------
  Future<void> _onDeleteProject(
      DeleteProject event,
      Emitter<ProjectState> emit,
      ) async {
    try {
      await repository.deleteProject(event.projectId);
      add(LoadProjects());
    } catch (_) {
      emit(  ProjectError('Failed to delete project'));
    }
  }

}
