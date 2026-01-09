import 'package:hive/hive.dart';

import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../models/project_hive.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final Box<ProjectHive> projectBox = Hive.box<ProjectHive>('projects');

  @override
  Future<List<Project>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return projectBox.values.map(_mapProject).toList();
  }

  @override
  Future<void> createProject(Project project) async {
    await projectBox.put(
      project.id,
      ProjectHive(
        id: project.id,
        name: project.name,
        description: project.description,
        archived: project.archived,
      ),
    );
  }

  // @override
  // Future<void> updateProject(Project project) async {
  //   await createProject(project);
  // }

  @override
  Future<void> archiveProject(String projectId, bool archived) async {
    final box = Hive.box<ProjectHive>('projects');
    final project = box.get(projectId);

    if (project != null) {
      project.archived = archived;
      await project.save();
    }
  }


  // ---------- Mapper ----------
  Project _mapProject(ProjectHive h) => Project(
    id: h.id,
    name: h.name,
    description: h.description,
    archived: h.archived,
  );

  @override
  Future<void> updateProject(Project project) async {
    final box = Hive.box<ProjectHive>('projects');
    final hiveProject = box.get(project.id);

    if (hiveProject != null) {
      hiveProject.name = project.name;
      hiveProject.description = project.description;
      hiveProject.assignedUsers = project.assignedUsers;
      hiveProject.archived = project.archived;
      await hiveProject.save();
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    final box = Hive.box<ProjectHive>('projects');
    await box.delete(projectId);
  }

}
