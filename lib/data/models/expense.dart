// import 'dart:ui';

// import 'package:demo/data/models/category.dart';

// class Expense {
//   final int id;
//   final String? title;
//   final String? deltaJsonBody;
//   final String? pinLock;
//   final bool hasAttachments;
//   final bool hasCanvas;
//   final Color backgroundColor;
//   final bool isPinned;
//   final bool isBookmarked;
//   final bool isArchieved;
//   final bool isTrash;
//   final bool isLocked;
//   final List<String> attachments;
//   final String? canvasData;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final Category? category;
//   final String? url;

//   Expense(
//       {required this.id,
//       required this.title,
//       required this.deltaJsonBody,
//       required this.pinLock,
//       required this.hasAttachments,
//       required this.hasCanvas,
//       required this.backgroundColor,
//       required this.isPinned,
//       required this.isBookmarked,
//       required this.isArchieved,
//       required this.isTrash,
//       required this.attachments,
//       required this.canvasData,
//       required this.createdAt,
//       required this.isLocked,
//       required this.updatedAt,
//       required this.category,
//       required this.url});

//   Map<String, dynamic> toMap() => {
//         'category': category?.id,
//         'id': id,
//         'title': title,
//         'deltaJsonBody': deltaJsonBody,
//         'pinLock': pinLock,
//         'hasAttachments': hasAttachments ? 1 : 0,
//         'hasCanvas': hasCanvas ? 1 : 0,
//         'backgroundColor': backgroundColor.value,
//         'isPinned': isPinned ? 1 : 0,
//         'isBookmarked': isBookmarked ? 1 : 0,
//         'isArchieved': isArchieved ? 1 : 0,
//         'isTrash': isTrash ? 1 : 0,
//         'attachments': attachments.join(','),
//         'canvasData': canvasData,
//         'createdAt': createdAt.toIso8601String(),
//         'isLocked': isLocked,
//         'updatedAt': updatedAt.toIso8601String(),
//         'url': url
//       };

//   static Expense fromMap(Map<String, dynamic> map) => Expense(
//         url: map["url"],
//         category: Category.getCategoryById(map['category']),
//         isLocked: map["isLocked"],
//         id: map['id'],
//         title: map['title'],
//         deltaJsonBody: map['deltaJsonBody'],
//         pinLock: map['pinLock'],
//         hasAttachments: map['hasAttachments'] == 1,
//         hasCanvas: map['hasCanvas'] == 1,
//         backgroundColor: Color(map['backgroundColor']),
//         isPinned: map['isPinned'] == 1,
//         isBookmarked: map['isBookmarked'] == 1,
//         isArchieved: map['isArchieved'] == 1,
//         isTrash: map['isTrash'] == 1,
//         attachments: map['attachments'].toString().split(','),
//         canvasData: map['canvasData'],
//         createdAt: DateTime.parse(map['createdAt']),
//         updatedAt: DateTime.parse(map['updatedAt']),
//       );
// }

