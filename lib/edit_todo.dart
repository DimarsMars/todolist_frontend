import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'api_service.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();


  late int _priority;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description ?? '';
    _deadlineController.text = widget.todo.deadline ?? '';
    _priority = widget.todo.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
  
  void _updateData() async {
    try {
      final deadlineString = _deadlineController.text.isNotEmpty 
          ? _deadlineController.text 
          : null;

      await ApiService.updateTodo(
        widget.todo.id,
        _titleController.text,
        _descriptionController.text,
        widget.todo.status,
        deadlineString,
        _priority,
      );
      
      Navigator.of(context).popUntil((route) => route.isFirst);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan perubahan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Tugas",
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Judul'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Deskripsi'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _priority,
            decoration: const InputDecoration(labelText: 'Prioritas'),
            items: const [
              DropdownMenuItem(value: 1, child: Text("Santai")),
              DropdownMenuItem(value: 2, child: Text("Sedang")),
              DropdownMenuItem(value: 3, child: Text("Harus Cepat Selesai")),
            ],
            onChanged: (nilaiBaru) {
              if (nilaiBaru != null) {
                setState(() {
                  _priority = nilaiBaru;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _deadlineController,
            decoration: const InputDecoration(
              labelText: 'Deadline',
            ),
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _updateData,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3C53),
                foregroundColor: Colors.white),
            child: const Text('Simpan Perubahan'),
          )
        ],
      ),
    );
  }
}