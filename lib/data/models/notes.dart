import 'dart:ui';

import 'package:demo/data/models/category.dart';

class Notes {
  final int id;
  final String? title;
  final String? deltaJsonBody;
  final String? pinLock;
  final bool hasAttachments;
  final bool hasCanvas;
  final Color backgroundColor;
  final bool isPinned;
  final bool isBookmarked;
  final bool isArchieved;
  final bool isTrash;
  final bool isLocked;
  final List<String> attachments;
  final String? canvasData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;
  final String? url;

  Notes(
      {required this.id,
      required this.title,
      required this.deltaJsonBody,
      required this.pinLock,
      required this.hasAttachments,
      required this.hasCanvas,
      required this.backgroundColor,
      required this.isPinned,
      required this.isBookmarked,
      required this.isArchieved,
      required this.isTrash,
      required this.attachments,
      required this.canvasData,
      required this.createdAt,
      required this.isLocked,
      required this.updatedAt,
      required this.category,
      required this.url});

  Map<String, dynamic> toMap() => {
        'category': category?.id,
        'id': id,
        'title': title,
        'deltaJsonBody': deltaJsonBody,
        'pinLock': pinLock,
        'hasAttachments': hasAttachments ? 1 : 0,
        'hasCanvas': hasCanvas ? 1 : 0,
        'backgroundColor': backgroundColor.value,
        'isPinned': isPinned ? 1 : 0,
        'isBookmarked': isBookmarked ? 1 : 0,
        'isArchieved': isArchieved ? 1 : 0,
        'isTrash': isTrash ? 1 : 0,
        'attachments': attachments.join(','),
        'canvasData': canvasData,
        'createdAt': createdAt.toIso8601String(),
        'isLocked': isLocked,
        'updatedAt': updatedAt.toIso8601String(),
        'url': url
      };

  static Notes fromMap(Map<String, dynamic> map) => Notes(
        url: map["url"],
        category: Category.getCategoryById(map['category']),
        isLocked: map["isLocked"],
        id: map['id'],
        title: map['title'],
        deltaJsonBody: map['deltaJsonBody'],
        pinLock: map['pinLock'],
        hasAttachments: map['hasAttachments'] == 1,
        hasCanvas: map['hasCanvas'] == 1,
        backgroundColor: Color(map['backgroundColor']),
        isPinned: map['isPinned'] == 1,
        isBookmarked: map['isBookmarked'] == 1,
        isArchieved: map['isArchieved'] == 1,
        isTrash: map['isTrash'] == 1,
        attachments: map['attachments'].toString().split(','),
        canvasData: map['canvasData'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );
}

// final deltaJson = jsonEncode(_controller.document.toDelta().toJson());

// final newNote = Notes(
//   id: 0,
//   title: 'Note title',
//   deltaJsonBody: deltaJson,
//   pinLock: null,
//   hasAttachments: false,
//   hasCanvas: false,
//   backgroundColor: Colors.black,
//   isPinned: false,
//   isBookmarked: false,
//   isArchieved: false,
//   isTrash: false,
//   attachments: [],
//   canvasPath: null,
//   createdAt: DateTime.now(),
// );

// // Save to SQLite using toMap()
// await db.insert('notes', newNote.toMap());
// final loadedDelta = Delta.fromJson(jsonDecode(note.deltaJsonBody!));
// final controller = QuillController(
//   document: Document.fromDelta(loadedDelta),
//   selection: const TextSelection.collapsed(offset: 0),
// );

// Saving canvas as JSON
// final canvasJsonData = jsonEncode(notifier.currentSketch.toJson());
// final newNote = Notes(
//   id: 0,
//   title: 'Note title',
//   deltaJsonBody: deltaJson,
//   pinLock: null,
//   hasAttachments: false,
//   hasCanvas: true, // Set to true if the note has a canvas
//   backgroundColor: Colors.white,
//   isPinned: false,
//   isBookmarked: false,
//   isArchieved: false,
//   isTrash: false,
//   attachments: [],
//   canvasData: canvasJsonData, // Save the canvas data as JSON
//   createdAt: DateTime.now(),
// );
// await db.insert('notes', newNote.toMap());

// Loading canvas from JSON
// final loadedNote = Notes.fromMap(mapFromDb);
// if (loadedNote.hasCanvas) {
//   final canvasJson = loadedNote.canvasData;
//   final sketch = Sketch.fromJson(jsonDecode(canvasJson!));
//   notifier.loadSketch(sketch); // Load the sketch into the ScribbleNotifier
// }
