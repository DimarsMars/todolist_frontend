import 'package:flutter/material.dart';
import 'api_service.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  int _priority = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Judul tidak boleh kosong")),
      );
      return;
    }

    try {
      await ApiService.createTodo(
        _titleController.text,
        _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        _deadlineController.text.isNotEmpty ? _deadlineController.text : null,
        _priority,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tugas Baru",
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
                setState(() { _priority = nilaiBaru; });
              }
            },
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _deadlineController,
            decoration: const InputDecoration(
              labelText: 'Deadline',
              hintText: 'Contoh: Besok sore',
            ),
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveData,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3C53),
                foregroundColor: Colors.white),
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }
}