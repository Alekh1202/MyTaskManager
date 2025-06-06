class Task {
  

  // Title of the task
  String title;
  // Indicates whether the task is completed or not
  bool isDone;
  // Unique identifier for the task
  // This can be used to update or delete the task later
  int id;

  Task({required this.title, required this.isDone, required this.id});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
      id: json['id'] as int,
    );
  }
  // // This method creates a copy of the Task object with updated values.
 Task copyWith({
    String? title,
    bool? isDone,
   
  }) {
    return Task(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      id:id,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone, 'id': id};
  }
}
