import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note.dart';

class StorageService {
  static const String _notesKey = 'notes_json';
  static const String _categoriesKey = 'categories';
  static const String _themesKey = 'darkTheme';

  Future<List<Note>> getNote() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey);
    if (notesJson == null) return [];
    return notesJson.map((e) => Note.fromMap(jsonDecode(e))).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => jsonEncode(n.toMap())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_categoriesKey) ?? ['General'];
  }

  Future<void> saveCategory(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, categories);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themesKey) ?? false;
  }

  Future<void> saveTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themesKey, dark);
  }
}
