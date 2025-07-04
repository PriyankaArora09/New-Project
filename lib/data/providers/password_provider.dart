import 'package:demo/data/database/password_db.dart';
import 'package:demo/data/models/password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordNotifier extends StateNotifier<AsyncValue<List<Password>>> {
  PasswordNotifier() : super(const AsyncValue.loading()) {
    loadPasswords();
  }

  Future<void> loadPasswords() async {
    state = const AsyncValue.loading();
    try {
      final passwords = await PasswordDb.instance.getAllPasswords();
      print('length of password list==============> ${passwords.length}');
      for (var pass in passwords) {
        print(pass);
      }
      state = AsyncValue.data(passwords);
    } catch (e, st) {
      print('Error loading passwords: $e at $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPassword(Password password) async {
    try {
      final id = await PasswordDb.instance.insertPassword(password);
      print('Inserted passwords with id: $id');
      await loadPasswords();
    } catch (e, st) {
      print('Error adding passwords: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePassword(Password password) async {
    try {
      await PasswordDb.instance.updatePassword(password);
      await loadPasswords();
    } catch (e, st) {
      print('Error updating passwords: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePassword(int id) async {
    try {
      await PasswordDb.instance.deletePassword(id);
      await loadPasswords();
    } catch (e, st) {
      print('Error deleting Password: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final passwordsNotifierProvider =
    StateNotifierProvider<PasswordNotifier, AsyncValue<List<Password>>>((ref) {
  return PasswordNotifier();
});

final trashedPasswordsProvider = Provider<AsyncValue<List<Password>>>((ref) {
  final allPasswords = ref.watch(passwordsNotifierProvider);
  return allPasswords.whenData(
    (passwords) => passwords.where((password) => password.isTrash).toList(),
  );
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final filteredPasswordsProvider = Provider<List<Password>>((ref) {
  final allPasswords = ref.watch(passwordsNotifierProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return allPasswords.when(
    data: (list) {
      final todays = list
          .where((e) =>
              e.createdAt.year == selectedDate.year &&
              e.createdAt.month == selectedDate.month &&
              e.createdAt.day == selectedDate.day)
          .toList();
      return todays.isNotEmpty
          ? todays
          : list
              .where((e) =>
                  e.createdAt.year == selectedDate.year &&
                  e.createdAt.month == selectedDate.month &&
                  e.createdAt.day == selectedDate.day - 1)
              .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
