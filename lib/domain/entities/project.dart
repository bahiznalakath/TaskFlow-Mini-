class Project {
  final String id;
  final String name;
  final String description;
  final bool archived;

  // ✅ NEW
  final List<String> assignedUsers;

  Project({
    required this.id,
    required this.name,
    required this.description,
    this.archived = false,
    this.assignedUsers = const [],
  });

  Project copyWith({
    String? name,
    String? description,
    bool? archived,
    List<String>? assignedUsers,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      archived: archived ?? this.archived,
      assignedUsers: assignedUsers ?? this.assignedUsers,
    );
  }
}
