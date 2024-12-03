class TaskModel {
  final String id;
  final String title;
  final DateTime dueDate;
  late final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['objectId'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
