class Todo {
  final int id;
  final String title;
  final String? description;
  final String? deadline;
  final int priority;
  final int status;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    required this.priority,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      priority: json['priority'] ?? 1,
      status: json['status'] ?? 0,
    );
  }
}