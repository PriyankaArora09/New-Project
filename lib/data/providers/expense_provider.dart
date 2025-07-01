import 'package:demo/data/database/expenses_db.dart';
import 'package:demo/data/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  ExpensesNotifier() : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await ExpensesDb.instance.getAllExpenses();
      print('length of expenses list==============> ${expenses.length}');
      for (var note in expenses) {
        print(note);
      }
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      print('Error loading expenses: $e at $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final id = await ExpensesDb.instance.insertExpense(expense);
      print('Inserted expense with id: $id');
      await loadExpenses();
    } catch (e, st) {
      print('Error adding expense: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await ExpensesDb.instance.updateExpense(expense);
      await loadExpenses();
    } catch (e, st) {
      print('Error updating Expense: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await ExpensesDb.instance.deleteExpense(id);
      await loadExpenses();
    } catch (e, st) {
      print('Error deleting Expense: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final expensesNotifierProvider =
    StateNotifierProvider<ExpensesNotifier, AsyncValue<List<Expense>>>((ref) {
  return ExpensesNotifier();
});

final archivedExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final allExpenses = ref.watch(expensesNotifierProvider);
  return allExpenses.whenData(
    (expenses) => expenses.where((expense) => expense.isArchived).toList(),
  );
});

final trashedExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final allExpenses = ref.watch(expensesNotifierProvider);
  return allExpenses.whenData(
    (expenses) => expenses.where((expense) => expense.isTrash).toList(),
  );
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final filteredExpensesProvider = Provider<List<Expense>>((ref) {
  final allExpenses = ref.watch(expensesNotifierProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return allExpenses.when(
    data: (list) {
      final todays = list
          .where((e) =>
              e.expenseDate.year == selectedDate.year &&
              e.expenseDate.month == selectedDate.month &&
              e.expenseDate.day == selectedDate.day)
          .toList();
      return todays.isNotEmpty
          ? todays
          : list
              .where((e) =>
                  e.expenseDate.year == selectedDate.year &&
                  e.expenseDate.month == selectedDate.month &&
                  e.expenseDate.day == selectedDate.day - 1)
              .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
