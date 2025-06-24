import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import '../widgets/category_select.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback themeChange;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.themeChange,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  List<String> _categories = [];
  String _selectedCategories = 'General';
  String? _filterCategory;

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterNotes);
    _upload();
  }

  Future<void> _upload() async {
    final notes = await _storageService.getNote();
    final categories = await _storageService.getCategories();

    setState(() {
      _notes = notes;
      _categories = categories;
      if (_categories.isEmpty) {
        _categories.add('General');
      }
      _selectedCategories = _categories.first;
    });

    _filterNotes();
  }

  Future<void> _saveNotes() async {
    await _storageService.saveNotes(_notes);
  }

  Future<void> _saveCategories() async {
    await _storageService.saveCategory(_categories);
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        final matchesCategory =
            _filterCategory == null || note.category == _filterCategory;
        final matchesSearch = note.content.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final newNote = Note(content: text, category: _selectedCategories);
      _notes.add(newNote);
      _noteController.clear();
      _saveNotes();
      _filterNotes();
    });
  }

  void _deleteNotes(int index) {
    setState(() {
      _notes.removeAt(index);
      _saveNotes();
      _filterNotes();
    });
  }

  void _editNotes(int index) {
    final editController = TextEditingController(text: _notes[index].content);
    String editCategory = _notes[index].category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: editController),
              DropdownButton<String>(
                value: editCategory,
                isExpanded: true,
                onChanged: (newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      editCategory = newCategory;
                    });
                  }
                },
                items: _categories
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Kaydet'),
              onPressed: () {
                setState(() {
                  _notes[index] = Note(
                    content: editController.text,
                    category: editCategory,
                  );
                  _saveNotes();
                  _filterNotes();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _categoryAddDialog() {
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Kategori Ekle'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(hintText: 'Kategori adı'),
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Ekle'),
              onPressed: () {
                final newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty &&
                    !_categories.contains(newCategory)) {
                  setState(() {
                    _categories.add(newCategory);
                    _selectedCategories = newCategory;
                    _saveCategories();
                  });
                }
                Navigator.pop(context);
                _filterNotes(); // filtreyi güncelle
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Defteri'),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.themeChange,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Ara...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterNotes();
                  },
                )
                    : null,
              ),
            ),
            SizedBox(height: 8),
            CategorySelect(
              categories: ['Tümü', ..._categories],
              selectedCategory: _filterCategory ?? 'Tümü',
              onCategoryChanged: (newCat) {
                setState(() {
                  _filterCategory = newCat == 'Tümü' ? null : newCat;
                  _filterNotes();
                });
              },
              onAddCategory: _categoryAddDialog,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Yeni Not',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ),
              onSubmitted: (_) => _addNote(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredNotes.isEmpty
                  ? Center(child: Text('Eşleşen not bulunamadı.'))
                  : ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = _filteredNotes[index];
                  final originalIndex = _notes.indexOf(note);
                  return NoteCard(
                    not: note,
                    onDelete: () => _deleteNotes(originalIndex),
                    onEdit: () => _editNotes(originalIndex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
