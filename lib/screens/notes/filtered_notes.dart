import 'dart:convert';
import 'dart:io';
import 'package:demo/constants/app_images.dart';
import 'package:demo/data/models/notes.dart';
import 'package:demo/data/providers/notes_provider.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/screens/notes/notes_drawer.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FilteredNotes extends ConsumerStatefulWidget {
  const FilteredNotes({super.key, required this.isTrash});
  final bool isTrash;

  @override
  ConsumerState<FilteredNotes> createState() => _FilteredNotesState();
}

class _FilteredNotesState extends ConsumerState<FilteredNotes> {
  final TextEditingController searchController = TextEditingController();

  List<Notes> notes = [];
  List<Notes> bookmarkedNotes = [];

  bool isList = false;
  bool showOptions = false;
  List<int> selectedItems = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final notesState = widget.isTrash
        ? ref.watch(trashedNotesProvider)
        : ref.watch(archivedNotesProvider);

    notes = notesState.when(
      data: (data) => data,
      error: (error, stackTrace) {
        return [];
      },
      loading: () {
        return [];
      },
    );

    return PopScope(
      canPop: !showOptions,
      onPopInvokedWithResult: (didPop, result) {
        if (showOptions) {
          setState(() {
            showOptions = !showOptions;
            selectedItems.clear();
          });
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: const NotesDrawer(),
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
              staggeredGrid(),
              10.height
            ],
          ),
        ),
      ),
    );
  }

  Widget filterRow() {
    if (showOptions) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                showOptions = false;
                selectedItems.clear();
              });
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryWhite,
              size: 20.sp,
            ),
          ),
          15.width,
          Expanded(
              child: Text(
            "${selectedItems.length} selected",
            style: AppTextStyle.style15500(myColor: AppColors.textColor),
          )),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textColor),
            tooltip: "Delete permanently",
            onPressed: () async {
              for (var id in selectedItems) {
                await ref.read(notesNotifierProvider.notifier).deleteNote(id);
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Selected items deleted permanently");
            },
          ),
          IconButton(
            icon: Icon(
                widget.isTrash ? Icons.archive_outlined : Icons.unarchive,
                color: AppColors.textColor),
            onPressed: () async {
              for (var id in selectedItems) {
                final note = notes.firstWhere((n) => n.id == id);
                await ref.read(notesNotifierProvider.notifier).updateNote(
                    note.copyWith(
                        isArchieved: widget.isTrash ? true : false,
                        updatedAt: DateTime.now()));
              }
              selectedItems.clear();
              showOptions = false;
              setState(() {});
              showSnack("Updated notes list");
            },
          ),
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
        prefix: InkWell(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(Icons.menu, color: AppColors.primaryWhite)),
        controller: searchController,
        hintText: "Search...",
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
            8.width,
          ],
        ),
      );
    }
  }

  Widget staggeredGrid() {
    return SingleChildScrollView(
      child: StaggeredGrid.count(
        axisDirection: AxisDirection.down,
        crossAxisCount: isList ? 1 : 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        children: List.generate(
          notes.length,
          (index) => StaggeredGridTile.fit(
            crossAxisCellCount: isList ? 2 : 1,
            child: gridContainer(
              index,
              notes[index],
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
                    ? SizedBox(
                        height: 15.h,
                        width: 15.w,
                        child: Checkbox(
                            checkColor: AppColors.primaryBlack,
                            activeColor: AppColors.primaryGraphics,
                            value: selectedItems.contains(note.id),
                            onChanged: (val) {
                              setState(() {
                                if (selectedItems.contains(note.id)) {
                                  selectedItems.remove(note.id);
                                } else {
                                  selectedItems.add(note.id!);
                                }
                                if (selectedItems.isEmpty) {
                                  showOptions = false;
                                }
                              });
                            }),
                      )
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
        ],
      ),
    );
  }
}
