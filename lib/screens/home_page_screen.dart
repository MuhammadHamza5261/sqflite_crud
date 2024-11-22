import 'package:flutter/material.dart';
import 'package:sqflite_crud/models/task_model.dart';
import 'package:sqflite_crud/service/data_base_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final DataBaseService _dataBaseService = DataBaseService();
  String? _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      floatingActionButton: _addTaskButton(),
      body: _taskList(),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Subscribe...',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_task == null || _task!.trim().isEmpty) return;
                    _dataBaseService.addTask(_task!.trim());
                    setState(() {
                      _task = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _taskList() {
    return FutureBuilder<List<TaskModel>>(
      future: _dataBaseService.getTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the data is loading
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there's an error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show a message if the list is empty
          return const Center(child: Text('No tasks available'));
        }

        // If data is loaded, show the list of tasks
        final tasks = snapshot.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            TaskModel taskModel = tasks[index];
            return ListTile(
              onLongPress: () {
                _dataBaseService.deleteTask(taskModel.id);
                setState(() {}); // Refresh the list after deletion
              },
              title: Text(taskModel.content),
              trailing: Checkbox(
                value: taskModel.status == 1,
                onChanged: (value) {
                  _dataBaseService.updateTask(taskModel.id, value == true ? 1 : 0);
                  setState(() {}); // Refresh the list after updating
                },
              ),
            );
          },
        );
      },
    );
  }
}
