class Subtask {
  final String id;
  final String taskId;
  final String title;
  final bool completed;
  final String? assignee;

  Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    this.completed = false,
    this.assignee,
  });

  Subtask copyWith({
    bool? completed,
    String? assignee,
    String? title,
  }) {
    return Subtask(
      id: id,
      taskId: taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      assignee: assignee ?? this.assignee,
    );
  }
}
