class SubExpense {
  final int id;
  final String? title;
  final double amount;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubExpense({
    required this.id,
    this.title,
    required this.amount,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'expenseDate': expenseDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static SubExpense fromMap(Map<String, dynamic> map) => SubExpense(
        id: map['id'],
        title: map['title'],
        amount: map['amount'] ?? 0.0,
        expenseDate: DateTime.parse(map['expenseDate']),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );

  SubExpense copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubExpense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SubExpense(id: $id, title: $title, amount: $amount, '
        'expenseDate: $expenseDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
