class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  final String source;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
    required this.source,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
      'source': source,
    };
  }
}
