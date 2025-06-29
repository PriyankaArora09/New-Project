import 'dart:convert';
import 'dart:io';
import 'package:demo/constants/app_images.dart';
import 'package:demo/data/models/notes.dart';
import 'package:demo/data/providers/notes_provider.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  List<Notes> notes = [];
  List<Notes> bookmarkedNotes = [];

  bool isList = false;
  bool showOptions = false;
  List<int> selectedItems = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.secondaryBackground,
            title: Text(title,
                style:
                    AppTextStyle.style15500(myColor: AppColors.primaryWhite)),
            content: Text(content,
                style: AppTextStyle.style13400(myColor: AppColors.textColor)),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesNotifierProvider);
    notesState.whenData((list) {
      final pinned = list.where((note) => note.isPinned).toList();
      final unpinned = list.where((note) => !note.isPinned).toList()
        ..sort((a, b) => b.id!.compareTo(a.id!));
      notes = [...pinned, ...unpinned];
      bookmarkedNotes = list.where((note) => note.isBookmarked).toList();
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: InkWell(
        onTap: () {
          AppNavigator.goToCreateNote(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          height: 40.h,
          width: 40.w,
          decoration: const BoxDecoration(
              color: AppColors.primaryTeal, shape: BoxShape.circle),
          child: const Icon(
            Icons.add,
            color: AppColors.primaryBlack,
          ),
        ),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          children: [
            40.height,
            filterRow(),
            10.height,
            tabsHeader(),
            10.height,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [staggeredGrid(false), staggeredGrid(true)],
              ),
            ),
            10.height
          ],
        ),
      ),
    );
  }

  Widget filterRow() {
    if (showOptions) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.errorColor),
            onPressed: () async {
              final confirm = await showConfirmationDialog("Delete Notes",
                  "Are you sure you want to delete selected notes permanently?");
              if (confirm) {
                for (var id in selectedItems) {
                  await ref.read(notesNotifierProvider.notifier).deleteNote(id);
                }
                selectedItems.clear();
                showOptions = false;
                setState(() {});
                showSnack("Deleted selected notes");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textColor),
            tooltip: "Move to Trash",
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(isTrash: true, updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Moved to trash");
            },
          ),
          IconButton(
            icon:
                const Icon(Icons.archive_outlined, color: AppColors.textColor),
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(note
                    .copyWith(isArchieved: true, updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Archived selected notes");
            },
          ),
          IconButton(
            icon:
                const Icon(Icons.push_pin_outlined, color: AppColors.textColor),
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(
                        isPinned: !note.isPinned, updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Updated pinned status");
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: AppColors.textColor),
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(
                        isBookmarked: !note.isBookmarked,
                        updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Updated bookmark status");
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, color: AppColors.textColor),
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(
                        isLocked: !note.isLocked, updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Updated lock status");
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear, color: AppColors.textColor),
            onPressed: () {
              selectedItems.clear();
              showOptions = false;
              setState(() {});
            },
          )
        ],
      );
    } else {
      return AppTextField(
        prefix: const Icon(Icons.search, color: AppColors.primaryWhite),
        controller: searchController,
        hintText: "Search notes",
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isList = !isList;
                });
              },
              child: Image.asset(
                isList ? AppImages.grid : AppImages.list,
                scale: isList ? 24.sp : 20.sp,
                color: AppColors.primaryWhite,
              ),
            ),
            12.width,
            Image.asset(
              AppImages.sort,
              scale: 20.sp,
              color: AppColors.primaryWhite,
            ),
            8.width,
          ],
        ),
      );
    }
  }

  Widget tabsHeader() {
    return SizedBox(
      height: 30.h,
      child: TabBar(
        dividerColor: AppColors.dividerColor,
        controller: _tabController,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 0.h),
        labelPadding: EdgeInsets.zero,
        labelColor: AppColors.primaryTeal,
        unselectedLabelColor: AppColors.textColor,
        indicatorColor: AppColors.primaryTeal,
        indicatorWeight: 0.2,
        labelStyle: AppTextStyle.style13600(myColor: AppColors.primaryTeal),
        tabs: const [Tab(text: "All"), Tab(text: "Bookmarks")],
      ),
    );
  }

  Widget staggeredGrid(bool isFav) {
    return SingleChildScrollView(
      child: StaggeredGrid.count(
        axisDirection: AxisDirection.down,
        crossAxisCount: isList ? 1 : 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        children: List.generate(
          _tabController.index == 0 ? notes.length : bookmarkedNotes.length,
          (index) => StaggeredGridTile.fit(
            crossAxisCellCount: isList ? 2 : 1,
            child: gridContainer(
              index,
              _tabController.index == 0 ? notes[index] : bookmarkedNotes[index],
            ),
          ),
        ),
      ),
    );
  }

  Widget gridContainer(int index, Notes note) {
    String noteContent = "";
    if (note.deltaJsonBody != null && note.deltaJsonBody!.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(note.deltaJsonBody!);
        if (decoded is List) {
          final buffer = StringBuffer();
          for (var op in decoded) {
            if (op is Map && op["insert"] != null) {
              buffer.write(op["insert"]);
            }
          }
          noteContent = buffer.toString();
          final int maxLength = note.attachments.isNotEmpty ? 120 : 180;
          if (noteContent.length > maxLength) {
            noteContent = "${noteContent.substring(0, maxLength)}...";
          }
        } else {
          noteContent = "Invalid content format";
        }
      } catch (e) {
        noteContent = "Error loading content";
      }
    } else {
      noteContent = "No content";
    }

    return InkWell(
      onTap: () {
        setState(() {
          if (showOptions) {
            if (selectedItems.contains(note.id)) {
              selectedItems.remove(note.id);
            } else {
              selectedItems.add(note.id!);
            }
          }
        });
      },
      onLongPress: () {
        setState(() {
          showOptions = true;
          selectedItems.add(note.id!);
        });
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: selectedItems.contains(note.id!)
                  ? AppColors.textfield
                  : note.backgroundColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showOptions
                    ? Checkbox(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: 0),
                        value: selectedItems.contains(note.id),
                        onChanged: (val) {
                          setState(() {
                            if (selectedItems.contains(note.id)) {
                              selectedItems.remove(note.id);
                            } else {
                              selectedItems.add(note.id!);
                            }
                          });
                        })
                    : const SizedBox.shrink(),
                (note.title != null && note.title!.isNotEmpty) || note.isPinned
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              note.title!,
                              style: AppTextStyle.style15500(
                                  myColor: AppColors.primaryWhite),
                            ),
                          ),
                          10.width,
                          note.isPinned
                              ? Icon(Icons.link,
                                  size: 18.sp,
                                  color: AppColors.textColor.withOpacity(0.5))
                              : const SizedBox.shrink(),
                        ],
                      )
                    : const SizedBox.shrink(),
                5.height,
                Text(
                  noteContent,
                  style:
                      AppTextStyle.style13400(myColor: AppColors.primaryWhite),
                ),
                if (note.attachments.isNotEmpty) ...[
                  8.height,
                  Wrap(
                    spacing: 5.w,
                    runSpacing: 5.h,
                    children: note.attachments.take(2).map((path) {
                      return SizedBox(
                        width: 50.w,
                        height: 50.w,
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                ]
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
            child: InkWell(
              onTap: () async {
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(
                        isBookmarked: !note.isBookmarked,
                        updatedAt: DateTime.now()));
              },
              child: Icon(
                !note.isBookmarked
                    ? Icons.bookmark_add_outlined
                    : Icons.bookmark_remove,
                size: 18.sp,
                color: AppColors.textColor.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}
