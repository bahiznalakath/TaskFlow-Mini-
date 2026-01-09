import 'package:equatable/equatable.dart';
import '../../../domain/entities/project.dart';

abstract class ProjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {}

class CreateProject extends ProjectEvent {
  final Project project;
  CreateProject(this.project);

  @override
  List<Object?> get props => [project];
}

// class ArchiveProject extends ProjectEvent {
//   final String projectId;
//   ArchiveProject(this.projectId);
//
//   @override
//   List<Object?> get props => [projectId];
// }
class ArchiveProject extends ProjectEvent {
  final String projectId;
  final bool isArchived; // ✅ CORRECT FIELD

  ArchiveProject({
    required this.projectId,
    required this.isArchived,
  });

  @override
  List<Object?> get props => [projectId, isArchived];


}
class UpdateProject extends ProjectEvent {
  final Project project;

  UpdateProject(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProject extends ProjectEvent {
  final String projectId;

  DeleteProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

