import 'package:demo/constants/app_images.dart';
import 'package:demo/screens/notes/color_picker.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final headingController = TextEditingController();
  final bodyController = TextEditingController();

  Color backgroundColor = AppColors.primaryBackground;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryWhite,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                DateFormat("dd MMMM yy").format(DateTime.now()),
                style: AppTextStyle.style15400(myColor: AppColors.primaryWhite),
              ),
            ),
            Image.asset(AppImages.pin, scale: 28.sp),
            15.width,
            Icon(Icons.bookmark_add_outlined,
                color: AppColors.primaryWhite, size: 20.sp),
            15.width,
            Icon(Icons.archive_outlined,
                color: AppColors.primaryWhite, size: 20.sp),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      bottomSheet: bottomSheet(),
      body: Padding(
        padding: AppPaddings.createNotePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingField(),
              10.height,
              bodyField(),
              DarkThemeColorPickerWidget(
                selectedColor: Colors.teal,
                onColorChanged: (color) {
                  setState(() {
                    backgroundColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(String hint, TextStyle hintStyle) =>
      InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: hint,
        hintStyle: hintStyle,
      );

  Widget headingField() {
    return TextFormField(
      controller: headingController,
      cursorHeight: 26.sp,
      cursorColor: AppColors.primaryWhite,
      style: AppTextStyle.style26400(myColor: AppColors.primaryWhite),
      decoration: getInputDecoration(
          "Heading", AppTextStyle.style26400(myColor: Colors.grey[600]!)),
    );
  }

  Widget bodyField() {
    return TextFormField(
      controller: bodyController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      cursorHeight: 16.sp,
      cursorColor: AppColors.primaryWhite,
      style: AppTextStyle.style16400(myColor: AppColors.primaryWhite),
      decoration: getInputDecoration(
          "Note", AppTextStyle.style16400(myColor: Colors.grey[600]!)),
    );
  }

  Widget bottomSheet() {
    return Container(
      constraints: BoxConstraints(maxHeight: 100.h),
      padding: AppPaddings.bottomSheetContainer,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => showModalBottomSheet(
              constraints: BoxConstraints(maxHeight: 200.h),
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => modalBottomSheetContent(),
            ),
            child: const Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.primaryTeal,
            ),
          ),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.attach_file, color: AppColors.primaryWhite),
              const Icon(Icons.text_format_outlined,
                  color: AppColors.primaryWhite),
              const Icon(Icons.circle, color: AppColors.primaryGraphics),
              Image.asset(AppImages.bgImage, scale: 28.sp),
              const Icon(Icons.mic, color: AppColors.primaryWhite),
            ],
          ),
        ],
      ),
    );
  }

  Widget modalBottomSheetContent() {
    return Container(
      padding: AppPaddings.bottomSheetContainer,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryTeal,
            ),
          ),
          12.height,
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.share, color: AppColors.primaryWhite),
              Icon(Icons.palette, color: AppColors.primaryWhite),
              Icon(Icons.group, color: AppColors.primaryWhite),
              Icon(Icons.highlight, color: AppColors.primaryWhite),
            ],
          ),
          40.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.attach_file, color: AppColors.primaryWhite),
              const Icon(Icons.text_format_outlined,
                  color: AppColors.primaryWhite),
              const Icon(Icons.circle, color: AppColors.primaryGraphics),
              Image.asset(AppImages.bgImage, scale: 28.sp),
              const Icon(Icons.mic, color: AppColors.primaryWhite),
            ],
          ),
        ],
      ),
    );
  }
}
