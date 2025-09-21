import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'api_service.dart';
import 'todo_detail.dart';
import 'add_todo.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
    late Future<List<Todo>> futureTodos;

  @override
  void initState() {
    super.initState();
    futureTodos = ApiService.getTodos();
  }

  String priorityText(int priority) {
    switch (priority) {
      case 1:
        return "Santai";
      case 2:
        return "Sedang";
      case 3:
        return "Harus Cepat Selesai";
      default:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do", 
          style: TextStyle(
            color: Color(0xFFF9F3EF),
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Color(0xFF1B3C53),
      ),
        body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada todo"));
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.status == 1,
                    onChanged: (value) async {
                      final newStatus = value == true ? 1 : 0;

                      await ApiService.updateTodo(
                        todo.id,
                        todo.title,
                        todo.description,
                        newStatus,
                        todo.deadline,
                        todo.priority,
                      );

                      // refresh tampilan
                      setState(() {
                        futureTodos = ApiService.getTodos();
                      });
                    },
                      activeColor: const Color(0xFFD2C1B6),
                      checkColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFD2C1B6), width: 2),
                  ),
                  title: Text(todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )),
                  subtitle: Text(
                    "Deadline: ${todo.deadline ?? '-'} | Priority: ${priorityText(todo.priority)}",
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailPage(todo: todo),
                      ),
                    );

                    setState(() {
                      futureTodos = ApiService.getTodos();
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
          if (result == true) {
            setState(() {
              futureTodos = ApiService.getTodos();
            });
          }
        },
        backgroundColor: Color(0xFF1B3C53),
        foregroundColor: Color(0xFFF9F3EF),
        child: const Icon(Icons.add),
      ),
    );
  }
}