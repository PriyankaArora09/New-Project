class Category {
  final int id;
  final String name;
  final String type;

  Category({
    required this.id,
    required this.name,
    required this.type,
  });

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
  ];

  // Convert Category object to a map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  // Convert map to Category object (from SQLite)
  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }

  // Helper method to get category by id
  static Category getCategoryById(int id) {
    return allCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => allCategories.first, // Fallback to the first category
    );
  }
}
