import 'dart:io';
import 'package:demo/constants/app_images.dart';
import 'package:demo/screens/notes/color_picker.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final headingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  ScrollController scrollController = ScrollController();

  final stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  String spokenText = '';

  List<String> filePaths = [];

  Color backgroundColor = AppColors.primaryBackground;
  // final ZefyrController _controller = ZefyrController();
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void dispose() {
    speech.cancel();
    // final delta = _controller.document.toDelta();
    // final jsonContent = delta.toJson();

    // Print the JSON content
    // print(jsonContent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {
            final delta = _controller.document.toDelta();
            final jsonContent = delta.toJson();

            Navigator.pop(context);

            // Print the JSON content
            print(jsonContent);
          },
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
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pickedFilesPreview(),
              headingField(),
              10.height,
              bodyField(),
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
    return quill.QuillEditor.basic(
      scrollController: scrollController,
      configurations: quill.QuillEditorConfigurations(
          enableScribble: true,
          controller: _controller,
          scrollable: false,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.newline,
          placeholder: 'Note',
          customStyles: quill.DefaultStyles(
            paragraph: quill.DefaultTextBlockStyle(
                AppTextStyle.style16400(myColor: AppColors.primaryWhite),
                const quill.VerticalSpacing(0.0, 0.0), // Vertical spacing
                const quill.VerticalSpacing(0.0, 0.0), // Line spacing
                null),
            placeHolder: quill.DefaultTextBlockStyle(
                AppTextStyle.style16400(myColor: Colors.grey[600]!),
                const quill.VerticalSpacing(3.0, 3.0), // Vertical spacing
                const quill.VerticalSpacing(0.0, 0.0), // Line spacing
                null),
          )),
    );
  }

  // Widget bodyField() {

  //   // ZefyrEditor(
  //   //   scrollController: scrollController,
  //   //   scrollable: false,
  //   //   controller: _controller,
  //   //   textCapitalization: TextCapitalization.none,
  //   //     TextFormField(
  //   //   controller: bodyController,
  //   //   maxLines: null,
  //   //   keyboardType: TextInputType.multiline,
  //   //   cursorHeight: 16.sp,
  //   //   cursorColor: AppColors.primaryWhite,
  //   //   style: AppTextStyle.style16400(myColor: AppColors.primaryWhite),
  //   //   decoration: getInputDecoration(
  //   //       "Note", AppTextStyle.style16400(myColor: Colors.grey[600]!)),
  //   // );
  // }

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
          bottomSheetBottomRow()
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () async {},
                  child:
                      const Icon(Icons.share, color: AppColors.primaryWhite)),
              const Icon(Icons.palette, color: AppColors.primaryWhite),
              const Icon(Icons.group, color: AppColors.primaryWhite),
              const Icon(Icons.highlight, color: AppColors.primaryWhite),
            ],
          ),
          40.height,
          bottomSheetBottomRow()
        ],
      ),
    );
  }

  Widget bottomSheetBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
            onTap: () {
              filePickerMethod();
            },
            child:
                const Icon(Icons.attach_file, color: AppColors.primaryWhite)),
        InkWell(
          onTap: () => showModalBottomSheet(
            constraints: BoxConstraints(maxHeight: 300.h),
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => textFormatterSheet(),
          ),
          child: const Icon(Icons.text_format_outlined,
              color: AppColors.primaryWhite),
        ),
        InkWell(
            onTap: () => showModalBottomSheet(
                  constraints: BoxConstraints(maxHeight: 300.h),
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => colorPickerBottomSheet(),
                ),
            child: const Icon(Icons.circle, color: AppColors.primaryGraphics)),
        // Image.asset(AppImages.bgImage, scale: 28.sp),
        InkWell(
            onTap: () {
              captureImage();
            },
            child:
                const Icon(Icons.photo_camera, color: AppColors.primaryWhite)),
        InkWell(
            onTap: () {
              showSpeechDialog();
            },
            child: const Icon(Icons.mic, color: AppColors.primaryWhite)),
      ],
    );
  }

  Widget colorPickerBottomSheet() {
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
          DarkThemeColorPickerWidget(
            selectedColor: backgroundColor == AppColors.primaryBackground
                ? null
                : backgroundColor,
            onColorChanged: (color) {
              setState(() {
                if (color == null) {
                  backgroundColor = AppColors.primaryBackground;
                } else {
                  backgroundColor = color;
                }
              });
            },
          ),
          40.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  backgroundColor = AppColors.primaryBackground;
                  setState(() {});
                },
                child: Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryWhite),
                      borderRadius: BorderRadius.circular(8.75.r),
                      color: AppColors.primaryBackground),
                  child: Icon(
                    Icons.remove,
                    color: AppColors.primaryWhite,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textFormatterSheet() {
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
          // ZefyrToolbar.basic(controller: _controller),
          quill.QuillSimpleToolbar(
            configurations: quill.QuillSimpleToolbarConfigurations(
              showClipboardCopy: false,
              showClipboardPaste: false,
              showDirection: false,
              showBackgroundColorButton: false,
              showUndo: false,
              showRedo: false,
              showLink: false,
              showFontFamily: false,
              showFontSize: false,
              showSearchButton: false,
              showClipboardCut: false,
              showQuote: false,
              showLineHeightButton: false,
              showSmallButton: false,
              showDividers: false,
              controller: _controller,
              buttonOptions: const quill.QuillSimpleToolbarButtonOptions(
                undoHistory: quill.QuillToolbarHistoryButtonOptions(),
                base: quill.QuillToolbarBaseButtonOptions(
                  afterButtonPressed: null,
                ),
              ),
            ),
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

  Future<void> showSpeechDialog() async {
    bool permanentlyErrored = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> startListening() async {
              bool available = await speech.initialize(
                onStatus: (status) {
                  debugPrint('Speech status: $status');
                  if (status == 'done' && isListening && !permanentlyErrored) {
                    // Only restart if not permanently errored
                    speech.listen(
                      onResult: (result) {
                        setState(() {
                          spokenText = result.recognizedWords;
                        });
                      },
                      listenOptions: stt.SpeechListenOptions(
                          partialResults: true, enableHapticFeedback: true),
                    );
                  }
                },
                onError: (error) {
                  debugPrint('Speech recognition error: $error');
                  if (error.permanent) {
                    permanentlyErrored = true;
                    if (mounted) {
                      setState(() => isListening = false);
                    }
                  }
                },
              );

              if (available && !permanentlyErrored) {
                setState(() {
                  isListening = true;
                  spokenText = '';
                });

                speech.listen(
                  onResult: (result) {
                    setState(() {
                      spokenText = result.recognizedWords;
                    });
                  },
                  listenOptions: stt.SpeechListenOptions(
                      partialResults: true, enableHapticFeedback: true),
                );
              } else {
                debugPrint('Speech not available or permanently errored');
                setState(() => isListening = false);
              }
            }

            void stopListening() {
              speech.stop();
              speech.cancel();
              setState(() => isListening = false);
            }

            return AlertDialog(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              backgroundColor: AppColors.textfield,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Speak Now",
                      style: AppTextStyle.style20500(
                          myColor: AppColors.primaryWhite),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        speech.stop();
                        speech.cancel();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20.sp,
                      ))
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.height,
                  Text(
                    spokenText.isEmpty && !isListening
                        ? 'Press the mic below to start listening...'
                        : spokenText.isEmpty || isListening
                            ? "Listening...."
                            : spokenText,
                    style:
                        AppTextStyle.style14400(myColor: AppColors.textColor),
                  ),
                  20.height,
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.grey,
                      size: 32,
                    ),
                    onPressed: () {
                      if (isListening) {
                        stopListening();
                      } else {
                        startListening();
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    speech.stop();
                    speech.cancel();
                    if (spokenText.isNotEmpty) {
                      final selection = _controller.selection;
                      _controller.document
                          .insert(selection.baseOffset, spokenText);
                    } else {
                      debugPrint("No speech input captured");
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style:
                        AppTextStyle.style15500(myColor: AppColors.primaryTeal),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> filePickerMethod() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'jpg',
        'jpeg',
        'png',
        'gif',
        'svg',
        'mp3',
        'mp4',
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      filePaths = result.files
          .where((file) => file.path != null)
          .map((file) => file.path!)
          .toList();

      setState(() {});

      // print("Picked files: ${filePaths.join(", ")}");
    }
  }

  Future<void> captureImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        filePaths.add(photo.path);
      });
    }
  }

  Widget pickedFilesPreview() {
    if (filePaths.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attachments:",
          style: AppTextStyle.style13500(myColor: AppColors.primaryWhite),
        ),
        8.height,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filePaths.map((path) {
            final isImage = path.endsWith('.jpg') ||
                path.endsWith('.jpeg') ||
                path.endsWith('.png') ||
                path.endsWith('.gif');

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: isImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(File(path), fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Icon(Icons.insert_drive_file, size: 32),
                        ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        filePaths.remove(path);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        16.height,
      ],
    );
  }
}
