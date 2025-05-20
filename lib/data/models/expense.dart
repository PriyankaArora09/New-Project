import 'dart:convert';
import 'package:demo/data/models/category.dart';
import 'package:demo/data/models/sub_expense.dart';

class Expense {
  final int id;
  final String? title;
  final double amount;
  final String currency;
  final String? description;
  final bool hasAttachments;
  final List<String> attachments;
  final bool isPinned;
  final bool isArchieved;
  final bool isTrash;
  final bool isRecurring;
  final String? recurringFrequency;
  final String? paymentMethod;
  final String? notes;
  final Category? category;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? parentExpenseId;
  final SubExpense? subExpense;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.description,
    required this.hasAttachments,
    required this.attachments,
    required this.isPinned,
    required this.isArchieved,
    required this.isTrash,
    required this.isRecurring,
    required this.recurringFrequency,
    required this.paymentMethod,
    required this.notes,
    required this.category,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.parentExpenseId,
    this.subExpense,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'currency': currency,
        'description': description,
        'hasAttachments': hasAttachments ? 1 : 0,
        'attachments': jsonEncode(attachments),
        'isPinned': isPinned ? 1 : 0,
        'isArchieved': isArchieved ? 1 : 0,
        'isTrash': isTrash ? 1 : 0,
        'isRecurring': isRecurring ? 1 : 0,
        'recurringFrequency': recurringFrequency,
        'paymentMethod': paymentMethod,
        'notes': notes,
        'category': category?.id,
        'expenseDate': expenseDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deletedAt': deletedAt?.toIso8601String(),
        'parentExpenseId': parentExpenseId,
        // Serialize subExpense recursively or null
        'subExpense': subExpense?.toMap(),
      };

  static Expense fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        title: map['title'],
        amount: map['amount'] ?? 0.0,
        currency: map['currency'] ?? 'USD',
        description: map['description'],
        hasAttachments: map['hasAttachments'] == 1,
        attachments: List<String>.from(jsonDecode(map['attachments'] ?? '[]')),
        isPinned: map['isPinned'] == 1,
        isArchieved: map['isArchieved'] == 1,
        isTrash: map['isTrash'] == 1,
        isRecurring: map['isRecurring'] == 1,
        recurringFrequency: map['recurringFrequency'],
        paymentMethod: map['paymentMethod'],
        notes: map['notes'],
        category: Category.getCategoryById(map['category']),
        expenseDate: DateTime.parse(map['expenseDate']),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        deletedAt:
            map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
        parentExpenseId: map['parentExpenseId'],
        subExpense: map['subExpense'] != null
            ? SubExpense.fromMap(Map<String, dynamic>.from(map['subExpense']))
            : null,
      );
}
