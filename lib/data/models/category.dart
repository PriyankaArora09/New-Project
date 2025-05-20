class Category {
  final int id;
  final String name;
  final String type;

  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Category.empty() {
    return Category(id: -1, name: '', type: '');
  }

  // A static list of categories that can be used to retrieve the category by its id
  static List<Category> allCategories = [
    Category(id: 1, name: 'Social Media', type: 'Password'),
    Category(id: 2, name: 'Email', type: 'Password'),
    Category(id: 3, name: 'Banking & Finance', type: 'Password'),
    Category(id: 4, name: 'Shopping', type: 'Password'),
    Category(id: 5, name: 'Entertainment', type: 'Password'),
    Category(id: 6, name: 'Personal', type: 'Password'),
    Category(id: 7, name: 'Work & Tools', type: 'Password'),
    Category(id: 8, name: 'Health', type: 'Password'),
    Category(id: 9, name: 'Utilities', type: 'Password'),
    Category(id: 10, name: 'Government & Ids', type: 'Password'),
    Category(id: 11, name: 'Miscellaneous', type: 'Password'),
    Category(id: 12, name: 'Food & Dining', type: 'Expense'),
    Category(id: 13, name: 'Transportation', type: 'Expense'),
    Category(id: 27, name: 'Housing & Rent', type: 'Expense'),
    Category(id: 14, name: 'Utilities', type: 'Expense'),
    Category(id: 15, name: 'Health & Fitness', type: 'Expense'),
    Category(id: 16, name: 'Entertainment', type: 'Expense'),
    Category(id: 17, name: 'Shopping', type: 'Expense'),
    Category(id: 18, name: 'Travel', type: 'Expense'),
    Category(id: 19, name: 'Education', type: 'Expense'),
    Category(id: 20, name: 'Personal Care', type: 'Expense'),
    Category(id: 21, name: 'Insurance', type: 'Expense'),
    Category(id: 22, name: 'Taxes', type: 'Expense'),
    Category(id: 23, name: 'Gifts & Donations', type: 'Expense'),
    Category(id: 24, name: 'Business', type: 'Expense'),
    Category(id: 25, name: 'Subscriptions', type: 'Expense'),
    Category(id: 26, name: 'Pets', type: 'Expense'),
    Category(id: 30, name: 'Kids', type: 'Expense'),
    Category(id: 28, name: 'Loan & Debt', type: 'Expense'),
    Category(id: 29, name: 'Office Supplies', type: 'Expense'),
    Category(id: 31, name: 'Miscellaneous', type: 'Expense'),
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }

  static Category getCategoryById(int id) {
    return allCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => Category.empty(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
