import 'package:demo/data/database/notes_db.dart';
import 'package:demo/data/models/notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends StateNotifier<AsyncValue<List<Notes>>> {
  NotesNotifier() : super(const AsyncValue.loading()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    state = const AsyncValue.loading();
    try {
      final notes = await NotesDatabase.instance.getAllNotes();
      print('length of notes list==============> ${notes.length}');
      for (var note in notes) {
        print(note);
      }
      state = AsyncValue.data(notes);
    } catch (e, st) {
      print('Error loading notes: $e at $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNote(Notes note) async {
    try {
      final id = await NotesDatabase.instance.insertNote(note);
      print('Inserted note with id: $id');
      await loadNotes();
    } catch (e, st) {
      print('Error adding note: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNote(Notes note) async {
    try {
      await NotesDatabase.instance.updateNote(note);
      await loadNotes();
    } catch (e, st) {
      print('Error updating note: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await NotesDatabase.instance.deleteNote(id);
      await loadNotes();
    } catch (e, st) {
      print('Error deleting note: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final notesNotifierProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Notes>>>((ref) {
  return NotesNotifier();
});
