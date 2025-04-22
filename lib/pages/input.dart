import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dueDateController = TextEditingController();

  void _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dueDateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  void _addTask() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _dueDateController.text.trim(),
      );

      final box = await Hive.openBox<Task>('tasksBox');
      await box.add(newTask);

      _titleController.clear();
      _descController.clear();
      _dueDateController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task added!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Input Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _dueDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: _pickDueDate,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please pick a due date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text("Add Task"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
