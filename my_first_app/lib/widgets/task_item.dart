import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function(String, bool) onToggleStatus;
  final Function(String) onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggleStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text('Due: ${task.dueDate.toLocal()}'),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          onToggleStatus(task.id, value!);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(task.id),
      ),
    );
  }
}
