import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'edit_todo.dart';
import 'api_service.dart';

class TodoDetailPage extends StatelessWidget {
  final Todo todo;

  const TodoDetailPage({super.key, required this.todo});

  String priorityText(int priority) {
    switch (priority) {
      case 1:
        return "Santai";
      case 2:
        return "Sedang";
      case 3:
        return "Harus Cepet Selesai";
      default:
        return "-";
    }
  }

  Future<void> _deleteTodo(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ApiService.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil dihapus')),
        );
        Navigator.of(context).pop(true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus tugas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tugas",
          style: TextStyle(
            color: Color(0xFFF9F3EF),
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
        backgroundColor: const Color(0xFF1B3C53),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteTodo(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(todo.description ?? '-'),
                  ),
                  const SizedBox(height: 16),
                  const Text("Prioritas", style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(priorityText(todo.priority)),
                  ),
                  const SizedBox(height: 16),
                  const Text("Deadline", style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(todo.deadline ?? '-'),
                  ),
                  const SizedBox(height: 16),
                  const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(todo.status == 1 ? "Selesai" : "Belum selesai"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTodoPage(todo: todo),
            ),
          );
          if (result == true) {
            Navigator.of(context).pop(true);
          }
        },
        backgroundColor: Color(0xFF1B3C53),
        foregroundColor: Color(0xFFF9F3EF),
        child: const Icon(Icons.update),
      ),
    );
  }
}