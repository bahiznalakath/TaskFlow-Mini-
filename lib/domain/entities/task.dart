enum TaskStatus { todo, inProgress, blocked, inReview, done }
enum TaskPriority { low, medium, high, critical }

class Task {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime startDate;
  final DateTime dueDate;
  final double estimate;
  final double timeSpent;
  final List<String> assignees;
  final List<String> labels;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.dueDate,
    required this.estimate,
    required this.timeSpent,
    required this.assignees,
    required this.labels,
  });

  /// ✅ REQUIRED FOR BLoC UPDATES
  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? dueDate,
    double? estimate,
    double? timeSpent,
    List<String>? assignees,
    List<String>? labels,
  }) {
    return Task(
      id: id,
      projectId: projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      estimate: estimate ?? this.estimate,
      timeSpent: timeSpent ?? this.timeSpent,
      assignees: assignees ?? this.assignees,
      labels: labels ?? this.labels,
    );
  }
}
