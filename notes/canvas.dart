import 'dart:convert';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryWhite,
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    right: BorderSide(
                                        color: AppColors.dividerColor))),
                            child: Scribble(
                              notifier: notifier,
                              drawPen: true,
                            ),
                          ),
                        ),

                        // Column(
                        //   children: [
                        //     _buildColorToolbar(context),
                        //     const VerticalDivider(width: 32),
                        //     _buildStrokeToolbar(context),
                        //     const Expanded(child: SizedBox()),
                        //     _buildPointerModeSwitcher(context),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        15.height,
                        _buildColorToolbar(context),
                        SizedBox(
                          height: 10.h,
                        ),
                        _buildStrokeToolbar(context),
                        10.height,
                        ..._buildActions(context)
                      ],
                    ),
                  )
                ],
              ),
            ),
            // 10.height,
            // _buildPointerModeSwitcher(context),
          ],
        ));
  }

  List<Widget> _buildActions(context) {
    return [
      SizedBox(
        height: 30.h,
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, value, child) => IconButton(
            icon: child as Icon,
            tooltip: "Undo",
            onPressed: notifier.canUndo ? notifier.undo : null,
          ),
          child: const Icon(Icons.undo, color: AppColors.primaryBackground),
        ),
      ),
      SizedBox(
        height: 30.h,
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, value, child) => IconButton(
            icon: child as Icon,
            tooltip: "Redo",
            onPressed: notifier.canRedo ? notifier.redo : null,
          ),
          child: const Icon(Icons.redo, color: AppColors.primaryBackground),
        ),
      ),
      SizedBox(
        height: 30.h,
        child: IconButton(
          icon: const Icon(Icons.clear, color: AppColors.primaryBackground),
          tooltip: "Clear",
          onPressed: notifier.clear,
        ),
      ),
      SizedBox(
        height: 30.h,
        child: IconButton(
          icon: const Icon(
            Icons.image,
            color: AppColors.primaryBackground,
          ),
          tooltip: "Show PNG Image",
          onPressed: () => _showImage(context),
        ),
      ),
      // IconButton(
      //   icon: const Icon(Icons.data_object),
      //   tooltip: "Show JSON",
      //   onPressed: () => _showJson(context),
      // ),
    ];
  }

  void _showImage(BuildContext context) async {
    final image = notifier.renderImage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Generated Image"),
        content: SizedBox.expand(
          child: FutureBuilder(
            future: image,
            builder: (context, snapshot) => snapshot.hasData
                ? Image.memory(snapshot.data!.buffer.asUint8List())
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showJson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sketch as JSON"),
        content: SizedBox.expand(
          child: SelectableText(
            jsonEncode(notifier.currentSketch.toJson()),
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _buildStrokeToolbar(BuildContext context) {
    return ValueListenableBuilder<ScribbleState>(
      valueListenable: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: state.map(
                  drawing: (s) => Color(s.selectedColor),
                  erasing: (_) => Colors.transparent,
                ),
                border: state.map(
                  drawing: (_) => null,
                  erasing: (_) => Border.all(width: 1),
                ),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildColorButton(context, color: Colors.black),
        4.height,
        _buildColorButton(context, color: Colors.red),
        4.height,
        _buildColorButton(context, color: Colors.green),
        4.height,
        _buildColorButton(context, color: Colors.blue),
        4.height,
        _buildColorButton(context, color: Colors.yellow),
        4.height,
        _buildColorButton(context, color: Colors.orange),
        4.height,
        _buildColorButton(context, color: Colors.pink),
        4.height,
        _buildColorButton(context, color: Colors.purple),
        4.height,
        _buildColorButton(context, color: Colors.brown),
        4.height,
        _buildColorButton(context, color: Colors.grey),
        4.height,
        _buildEraserButton(context),
      ],
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier.select(
          (value) => value.allowedPointersMode,
        ),
        builder: (context, value, child) {
          return SegmentedButton<ScribblePointerMode>(
            multiSelectionEnabled: false,
            emptySelectionAllowed: false,
            onSelectionChanged: (v) => notifier.setAllowedPointersMode(v.first),
            segments: const [
              ButtonSegment(
                value: ScribblePointerMode.all,
                icon: Icon(Icons.touch_app),
                label: Text("All pointers"),
              ),
              ButtonSegment(
                value: ScribblePointerMode.penOnly,
                icon: Icon(Icons.draw),
                label: Text("Pen only"),
              ),
            ],
            selected: {value},
          );
        });
  }

  Widget _buildEraserButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value is Erasing),
      builder: (context, value, child) => ColorButton(
        color: Colors.transparent,
        outlineColor: Colors.black,
        isActive: value,
        onPressed: () => notifier.setEraser(),
        child: const Icon(
          Icons.cleaning_services,
          size: 14,
          color: AppColors.primaryBackground,
        ),
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
  }) {
    return ValueListenableBuilder(
      valueListenable: notifier.select(
          (value) => value is Drawing && value.selectedColor == color.value),
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ColorButton(
          color: color,
          isActive: value,
          onPressed: () => notifier.setColor(color),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    required this.color,
    required this.isActive,
    required this.onPressed,
    this.outlineColor,
    this.child,
    super.key,
  });

  final Color color;

  final Color? outlineColor;

  final bool isActive;

  final VoidCallback onPressed;

  final Icon? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 30,
      width: 30,
      duration: kThemeAnimationDuration,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: switch (isActive) {
              true => outlineColor ?? color,
              false => Colors.transparent,
            },
            width: 1,
          ),
        ),
      ),
      child: IconButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          side: isActive
              ? const BorderSide(color: Colors.white, width: 2)
              : const BorderSide(color: Colors.transparent),
        ),
        onPressed: onPressed,
        icon: child ?? const SizedBox(),
      ),
    );
  }
}
