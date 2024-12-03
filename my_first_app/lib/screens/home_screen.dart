import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample tasks for now
  List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Buy groceries',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
    ),
    TaskModel(
      id: '2',
      title: 'Complete Flutter project',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isCompleted: false,
    ),
    TaskModel(
      id: '3',
      title: 'Attend meeting with client',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickTask'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add-task').then(
                  (_) => setState(() {})); // Refresh when a new task is added
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (ctx, index) => TaskItem(
          task: _tasks[index],
          onToggleStatus: (taskId, isCompleted) {
            setState(() {
              _tasks[index].isCompleted = isCompleted;
            });
          },
          onDelete: (taskId) {
            setState(() {
              _tasks.removeWhere((task) => task.id == taskId);
            });
          },
        ),
      ),
    );
  }
}
