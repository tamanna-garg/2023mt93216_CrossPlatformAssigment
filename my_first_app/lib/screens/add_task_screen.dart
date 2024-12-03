import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  DateTime? _dueDate;

  void _submitTask() async {
    if (_titleController.text.isEmpty || _dueDate == null) {
      return;
    }

    try {
      final task = TaskModel(
        id: '',
        title: _titleController.text,
        dueDate: _dueDate!,
        isCompleted: false,
      );

      await TaskService.addTask(task);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _dueDate == null
                      ? 'No Date Chosen'
                      : 'Due Date: ${_dueDate!.toLocal()}',
                ),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dueDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Choose Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
