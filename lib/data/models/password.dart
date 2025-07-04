import 'package:demo/data/models/category.dart';

class Password {
  final int? id;
  final String? title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  final Category? category;

  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isArchieve;
  final bool isTrash;

  final bool has2FA;
  final String? twoFactorSecret;

  Password({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.website,
    this.notes,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isArchieve,
    required this.isTrash,
    this.has2FA = false,
    this.twoFactorSecret,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'website': website,
        'notes': notes,
        'category': category!.id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isPinned': isPinned ? 1 : 0,
        'isArchieve': isArchieve ? 1 : 0,
        'isTrash': isTrash ? 1 : 0,
        'has2FA': has2FA ? 1 : 0,
        'twoFactorSecret': twoFactorSecret,
      };

  static Password fromMap(Map<String, dynamic> map) => Password(
        id: map['id'],
        title: map['title'],
        username: map['username'],
        password: map['password'],
        website: map['website'],
        notes: map['notes'],
        category: Category.getCategoryById(map['category']),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        isPinned: map['isPinned'] == 1,
        isArchieve: map['isArchieve'] == 1,
        isTrash: map['isTrash'] == 1,
        has2FA: map['has2FA'] == 1,
        twoFactorSecret: map['twoFactorSecret'],
      );

  Password copyWith({
    int? id,
    String? title,
    String? username,
    String? password,
    String? website,
    String? notes,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchieve,
    bool? isTrash,
    bool? has2FA,
    String? twoFactorSecret,
  }) {
    return Password(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isArchieve: isArchieve ?? this.isArchieve,
      isTrash: isTrash ?? this.isTrash,
      has2FA: has2FA ?? this.has2FA,
      twoFactorSecret: twoFactorSecret ?? this.twoFactorSecret,
    );
  }

  @override
  String toString() {
    return 'Password(id: $id, title: $title, username: $username, password: $password, '
        'website: $website, notes: $notes, category: ${category?.name}, '
        'createdAt: $createdAt, updatedAt: $updatedAt, '
        'isPinned: $isPinned, isArchieve: $isArchieve, isTrash: $isTrash, '
        'has2FA: $has2FA, twoFactorSecret: $twoFactorSecret)';
  }
}
