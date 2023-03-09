import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joint_camp/components/todo_card.dart';
import 'package:joint_camp/model/todo_model.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final todos = [
    TodoModel(
        task: 'Belajar Rust', createdAt: DateTime.now().toIso8601String()),
    TodoModel(
        task: 'Belajar Golang', createdAt: DateTime.now().toIso8601String()),
    TodoModel(
        task: 'Belajar Flutter', createdAt: DateTime.now().toIso8601String()),
    TodoModel(
        task: 'Belajar Merelakannya',
        createdAt: DateTime.now().toIso8601String()),
  ];

  String newTodoName = '';
  DateTime newTodoDate = DateTime.now();

  final TextEditingController _todoNameController = TextEditingController();
  final TextEditingController _todoDateController = TextEditingController();

  void _showNewTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoNameController,
                decoration: const InputDecoration(hintText: "Todo Name"),
                onChanged: (value) {
                  newTodoName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _todoDateController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                decoration: const InputDecoration(
                  hintText: "Todo Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // ignore: unnecessary_null_comparison
                if (newTodoName.isNotEmpty && newTodoDate != null) {
                  setState(() {
                    todos.add(TodoModel(
                      task: newTodoName,
                      createdAt: newTodoDate.toIso8601String(),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      final DateFormat formatter = DateFormat.yMMMMd();
      setState(() {
        newTodoDate = pickedDate;
        _todoDateController.text = formatter.format(newTodoDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "JOINTS Todo",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: todos.map((e) => TodoCard(model: e)).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewTodoDialog(context);
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
