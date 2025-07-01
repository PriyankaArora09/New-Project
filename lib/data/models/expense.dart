import 'dart:convert';

import 'package:demo/data/models/category.dart';
import 'package:demo/data/models/sub_expense.dart';

class Expense {
  final int? id;
  final String? title;
  final double amount;
  final String currency;
  final String? description;
  final bool hasAttachments;
  final List<String> attachments;
  final bool isPinned;
  final bool isArchived;
  final bool isTrash;
  final bool isRecurring;
  final String? recurringFrequency;
  final String? paymentMethod;
  final String? notes;
  final Category? category;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubExpense> subExpenses;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.description,
    required this.hasAttachments,
    required this.attachments,
    required this.isPinned,
    required this.isArchived,
    required this.isTrash,
    required this.isRecurring,
    required this.recurringFrequency,
    required this.paymentMethod,
    required this.notes,
    required this.category,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.subExpenses,
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
        'isArchived': isArchived ? 1 : 0,
        'isTrash': isTrash ? 1 : 0,
        'isRecurring': isRecurring ? 1 : 0,
        'recurringFrequency': recurringFrequency,
        'paymentMethod': paymentMethod,
        'notes': notes,
        'category': category?.id,
        'expenseDate': expenseDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'subExpenses': jsonEncode(subExpenses.map((e) => e.toMap()).toList()),
      };

  static Expense fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        title: map['title'],
        amount: map['amount']?.toDouble() ?? 0.0,
        currency: map['currency'] ?? 'USD',
        description: map['description'],
        hasAttachments: map['hasAttachments'] == 1,
        attachments:
            List<String>.from(jsonDecode(map['attachments'] ?? '[]') as List),
        isPinned: map['isPinned'] == 1,
        isArchived: map['isArchived'] == 1,
        isTrash: map['isTrash'] == 1,
        isRecurring: map['isRecurring'] == 1,
        recurringFrequency: map['recurringFrequency'],
        paymentMethod: map['paymentMethod'],
        notes: map['notes'],
        category: Category.getCategoryById(map['category']),
        expenseDate: DateTime.parse(map['expenseDate']),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        subExpenses: (map['subExpenses'] != null && map['subExpenses'] != '')
            ? (jsonDecode(map['subExpenses']) as List)
                .map((e) => SubExpense.fromMap(e))
                .toList()
            : [],
      );

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    String? currency,
    String? description,
    bool? hasAttachments,
    List<String>? attachments,
    bool? isPinned,
    bool? isArchived,
    bool? isTrash,
    bool? isRecurring,
    String? recurringFrequency,
    String? paymentMethod,
    String? notes,
    Category? category,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SubExpense>? subExpenses,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      attachments: attachments ?? this.attachments,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isTrash: isTrash ?? this.isTrash,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subExpenses: subExpenses ?? this.subExpenses,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, currency: $currency, '
        'description: $description, hasAttachments: $hasAttachments, attachments: $attachments, '
        'isPinned: $isPinned, isArchived: $isArchived, isTrash: $isTrash, isRecurring: $isRecurring, '
        'recurringFrequency: $recurringFrequency, paymentMethod: $paymentMethod, notes: $notes, '
        'category: ${category?.id}, expenseDate: $expenseDate, createdAt: $createdAt, '
        'updatedAt: $updatedAt, subExpenses: $subExpenses)';
  }
}
