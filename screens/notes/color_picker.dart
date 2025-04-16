import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class DarkThemeColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const DarkThemeColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      color: selectedColor,
      onColorChanged: onColorChanged,
      pickersEnabled: const {
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
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
