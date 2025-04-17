import 'package:demo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkThemeColorPickerWidget extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color?> onColorChanged;

  const DarkThemeColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      height: 35.h,
      width: 35.w,
      borderColor: AppColors.primaryWhite,
      hasBorder: true,
      color: selectedColor ?? Colors.transparent,
      onColorChanged: (color) => onColorChanged(color),
      pickersEnabled: const {
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.custom: false,
      },
      customColorSwatchesAndNames: {
        const ColorSwatch(0x00000000, {0: Colors.transparent}): 'No Color',
        ColorSwatch(0xffbb86fc, {0: Colors.purple[200]!}): 'Purple',
        ColorSwatch(0xff03dac5, {0: Colors.teal[200]!}): 'Teal',
      },
      enableShadesSelection: false,
      heading: null,
      subheading: null,
      wheelSubheading: null,
      showMaterialName: false,
      showColorName: false,
      showColorCode: false,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyButton: false,
        pasteButton: false,
        longPressMenu: false,
      ),
    );
  }
}
