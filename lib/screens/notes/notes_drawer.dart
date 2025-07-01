import 'package:demo/data/providers/notes_provider.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesDrawer extends ConsumerWidget {
  const NotesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all notes
    final notesState = ref.watch(notesNotifierProvider);

    // Derive notes lists
    final totalNotes = notesState.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    final bookmarkedNotes = notesState.when(
      data: (list) => list.where((note) => note.isBookmarked).length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    final archiveNotesState = ref.watch(archivedNotesProvider);
    final archivedNotes = archiveNotesState.when(
      data: (data) => data.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    final trashNotesState = ref.watch(trashedNotesProvider);
    final trashNotes = trashNotesState.when(
      data: (data) => data.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      height: double.infinity,
      constraints: BoxConstraints(maxWidth: 250.w),
      color: AppColors.secondaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.height,
          Text('My Notes',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          12.height,
          _StatTile(label: "Total Notes", count: totalNotes),
          _StatTile(label: "Bookmarked Notes", count: bookmarkedNotes),
          _StatTile(label: "Archived Notes", count: archivedNotes),
          _StatTile(label: "Trashed Notes", count: trashNotes),
          Divider(height: 32.h),
          InkWell(
            onTap: () {
              AppNavigator.goToArchivedNotes(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.archive,
                  color: Colors.grey[700],
                  size: 20.sp,
                ),
                6.width,
                Expanded(
                  child: Text("Archived Notes",
                      style: AppTextStyle.style15400(
                          myColor: AppColors.primaryWhite)),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryWhite,
                  size: 14.sp,
                )
              ],
            ),
          ),
          20.height,
          InkWell(
            onTap: () {
              AppNavigator.goToTrashNotes(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.grey[700],
                  size: 20.sp,
                ),
                6.width,
                Expanded(
                  child: Text("Trash",
                      style: AppTextStyle.style15400(
                          myColor: AppColors.primaryWhite)),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryWhite,
                  size: 14.sp,
                )
              ],
            ),
          ),
          const Spacer(),
          AppButton.adminAppButton(
              text: "Create New Note",
              onTap: () {
                // Navigator.pop(context);
                AppNavigator.goToCreateNote(context);
              },
              color: AppColors.primaryTeal,
              textColor: AppColors.primaryBlack),
          15.height,
          AppButton.adminAppButton(
              text: "Switch Space",
              onTap: () {
                AppNavigator.goToDashboard(context);
              },
              color: AppColors.primaryGraphics,
              textColor: AppColors.primaryBlack),
          40.height
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;

  const _StatTile({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyle.style14400(myColor: AppColors.textColor)),
          Text('$count',
              style: AppTextStyle.style14500(myColor: AppColors.primaryWhite)),
        ],
      ),
    );
  }
}
