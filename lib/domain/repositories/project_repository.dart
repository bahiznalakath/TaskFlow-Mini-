import '../entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> fetchProjects();
  Future<void> createProject(Project project);
  Future<void> archiveProject(String projectId, bool archived);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String projectId);
}
