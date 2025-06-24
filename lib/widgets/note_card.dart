import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note not;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NoteCard({
    super.key,
    required this.not,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(not.content),
        subtitle: Text('Kategori: ${not.category}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onEdit,
      ),
    );
  }
}
