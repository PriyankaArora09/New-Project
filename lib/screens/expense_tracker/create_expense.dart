import 'dart:io';

import 'package:demo/constants/app_images.dart';
import 'package:demo/data/models/category.dart';
import 'package:demo/data/models/sub_expense.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_dialogs.dart';
import 'package:demo/widgets/app_dropdown.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateExpense extends StatefulWidget {
  const CreateExpense({super.key});

  @override
  State<CreateExpense> createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  String? title;
  double? amount;
  String currency = 'USD';
  String? description;
  String? paymentMethod;
  String? location;
  String? url;
  String? recurringFrequency;
  List<String> tags = [];
  bool isRecurring = false;
  bool isPinned = false;
  bool isArchieved = false;
  bool isReimbursable = false;
  bool isTaxDeductible = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController subAmountController = TextEditingController();
  final TextEditingController subDateController = TextEditingController();

  List<String> currencies = ['USD', 'EUR', 'INR'];
  List<String> frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  List<String> paymentOptions = ["Cash", "Card", "UPI"];

  String selectedPaymentMode = "";
  String selectedCurrency = "";
  String selectedFrequency = "";

  DateTime? selectedDate;
  DateTime? subDate;

  List<SubExpense> subExpenses = [];

  List<PlatformFile> attachments = [];

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        attachments.addAll(result.files);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  final expenseCategories = Category.allCategories
      .where((category) => category.type == 'Expense')
      .toList();

  Category selectedCategory = Category.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          leadingWidth: 40.w,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
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
                  "Create Expense",
                  style:
                      AppTextStyle.style15400(myColor: AppColors.primaryWhite),
                ),
              ),
              Image.asset(AppImages.pin, scale: 28.sp),
              15.width,
              InkWell(
                onTap: () {},
                child: Icon(Icons.archive_outlined,
                    color: AppColors.primaryWhite, size: 20.sp),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryBackground,
        ),
        body: Padding(
          padding: AppPaddings.screenPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style:
                      AppTextStyle.style12400(myColor: AppColors.primaryWhite),
                ),
                5.height,
                AppTextField(
                  controller: titleController,
                  hintText: "Add title",
                ),
                10.height,
                Text(
                  "Description",
                  style:
                      AppTextStyle.style12400(myColor: AppColors.primaryWhite),
                ),
                5.height,
                AppTextField(
                  controller: descriptionController,
                  hintText: "Add description",
                ),
                10.height,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount",
                            style: AppTextStyle.style12400(
                                myColor: AppColors.primaryWhite),
                          ),
                          5.height,
                          AppTextField(
                            prefixText: "\$",
                            controller: amountController,
                            hintText: "Add amount",
                          ),
                        ],
                      ),
                    ),
                    20.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Currency",
                            style: AppTextStyle.style12400(
                                myColor: AppColors.primaryWhite),
                          ),
                          5.height,
                          AppDropDown.appDropdown(context,
                              value: selectedCurrency == ""
                                  ? null
                                  : selectedCurrency, onChanged: (val) {
                            setState(() {
                              selectedCurrency = val;
                            });
                          },
                              items: currencies
                                  .map<DropdownMenuItem<String>>((String mode) {
                                return DropdownMenuItem<String>(
                                  value: mode,
                                  child: Text(
                                    mode,
                                    style: AppTextStyle.style12400(
                                        myColor: AppColors.textColor),
                                  ),
                                );
                              }).toList(),
                              width: double.maxFinite),
                        ],
                      ),
                    ),
                  ],
                ),
                10.height,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: AppTextStyle.style12400(
                              myColor: AppColors.primaryWhite,
                            ),
                          ),
                          5.height,
                          GestureDetector(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  dateController.text =
                                      DateFormat('yyyy-MM-dd').format(picked);
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: AppTextField(
                                controller: dateController,
                                hintText: "Select Date",
                                suffix: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primaryGraphics,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Method",
                            style: AppTextStyle.style12400(
                                myColor: AppColors.primaryWhite),
                          ),
                          5.height,
                          AppDropDown.appDropdown(context,
                              value: selectedPaymentMode == ""
                                  ? null
                                  : selectedPaymentMode, onChanged: (val) {
                            setState(() {
                              selectedPaymentMode = val;
                            });
                          },
                              items: paymentOptions
                                  .map<DropdownMenuItem<String>>((String mode) {
                                return DropdownMenuItem<String>(
                                  value: mode,
                                  child: Text(
                                    mode,
                                    style: AppTextStyle.style12400(
                                        myColor: AppColors.textColor),
                                  ),
                                );
                              }).toList(),
                              width: double.maxFinite),
                        ],
                      ),
                    ),
                  ],
                ),
                10.height,
                Text(
                  "Category",
                  style:
                      AppTextStyle.style12400(myColor: AppColors.primaryWhite),
                ),
                5.height,
                AppDropDown.appDropdown(
                  menuHeight: 300.h,
                  isModel: true,
                  context,
                  value: selectedCategory == Category.empty()
                      ? null
                      : selectedCategory,
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  items: expenseCategories
                      .map<DropdownMenuItem<Category>>((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(
                        category.name,
                        style: AppTextStyle.style12400(
                            myColor: AppColors.textColor),
                      ),
                    );
                  }).toList(),
                  width: double.maxFinite,
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Is Recurring?",
                      style: AppTextStyle.style12400(
                          myColor: AppColors.primaryWhite),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                          trackOutlineColor:
                              const WidgetStatePropertyAll(Colors.white),
                          inactiveThumbColor: const Color(0xffB5B5B5),
                          inactiveTrackColor: const Color(0xffECF0F1),
                          activeTrackColor: AppColors.primaryGraphics,
                          activeColor: AppColors.primaryWhite,
                          value: isRecurring,
                          onChanged: (val) =>
                              setState(() => isRecurring = val)),
                    ),
                  ],
                ),
                if (isRecurring) ...[
                  Text(
                    "Recurring Frequency",
                    style: AppTextStyle.style12400(
                        myColor: AppColors.primaryWhite),
                  ),
                  5.height,
                  AppDropDown.appDropdown(context,
                      value: selectedFrequency == "" ? null : selectedFrequency,
                      onChanged: (val) {
                    setState(() {
                      selectedFrequency = val;
                    });
                  },
                      items: frequencies
                          .map<DropdownMenuItem<String>>((String mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(
                            mode,
                            style: AppTextStyle.style12400(
                                myColor: AppColors.textColor),
                          ),
                        );
                      }).toList(),
                      width: double.maxFinite),
                ],
                10.height,
                Text(
                  "Attachments (if any)",
                  style:
                      AppTextStyle.style12400(myColor: AppColors.primaryWhite),
                ),
                5.height,
                Wrap(
                  spacing: 20.w,
                  runSpacing: 10.h,
                  children: [
                    // Existing Add Button
                    InkWell(
                      onTap: _pickFile,
                      child: Container(
                        height: 100.h,
                        width: 100.w,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.textfield,
                        ),
                        child: const Icon(
                          Icons.add_circle_outline_outlined,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),

                    // Attachments preview
                    ...attachments.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;

                      bool isImage = file.extension == 'jpg' ||
                          file.extension == 'jpeg' ||
                          file.extension == 'png';

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 100.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.textfield,
                              image: isImage
                                  ? DecorationImage(
                                      image: FileImage(File(file.path!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: isImage
                                ? null
                                : const Center(
                                    child: Icon(Icons.picture_as_pdf,
                                        color: AppColors.textColor),
                                  ),
                          ),
                          Positioned(
                            top: -3,
                            right: -3,
                            child: GestureDetector(
                              onTap: () => _removeAttachment(index),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                if (subExpenses.isNotEmpty) ...[
                  10.height,
                  ListView.builder(
                      itemCount: subExpenses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: subExpenseContainer(index),
                        );
                      })
                ],
                15.height,
                InkWell(
                  onTap: () {
                    subDateController.clear();
                    subTitleController.clear();
                    subAmountController.clear();

                    AppDialogs.showCustomDialog(
                      context: context,
                      heading: "Add Sub-Expense",
                      positiveButtonText: "Create",
                      negativeButtonText: "Cancel",
                      maxHeight: 500.h,
                      maxWidth: double.maxFinite,
                      onPressedDone: () {
                        subExpenses.add(SubExpense(
                            title: subTitleController.text,
                            id: 1,
                            amount: double.parse(subAmountController.text),
                            expenseDate: subDate!,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()));
                        setState(() {});
                      },
                      showCancel: true,
                      isDelete: false,
                      children: [
                        Text(
                          "Title",
                          style: AppTextStyle.style12400(
                              myColor: AppColors.primaryWhite),
                        ),
                        5.height,
                        AppTextField(
                          controller: subTitleController,
                          hintText: "Add title",
                        ),
                        10.height,
                        Text(
                          "Amount",
                          style: AppTextStyle.style12400(
                              myColor: AppColors.primaryWhite),
                        ),
                        5.height,
                        AppTextField(
                          prefixText: "\$",
                          controller: subAmountController,
                          hintText: "Add amount",
                        ),
                        10.height,
                        Text(
                          "Date",
                          style: AppTextStyle.style12400(
                            myColor: AppColors.primaryWhite,
                          ),
                        ),
                        5.height,
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: subDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                subDate = picked;
                                subDateController.text =
                                    DateFormat('yyyy-MM-dd').format(picked);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: AppTextField(
                              controller: subDateController,
                              hintText: "Select Date",
                              suffix: Icon(
                                Icons.calendar_month,
                                color: AppColors.primaryGraphics,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Text(
                    "Add Sub-expense",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryTeal,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget subExpenseContainer(int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        title: Text(
          subExpenses[index].title ?? "",
          style: AppTextStyle.style14400(myColor: AppColors.primaryWhite),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${subExpenses[index].amount}",
              style: AppTextStyle.style14400(myColor: AppColors.errorColor),
            ),
            Text(
              subExpenses[index].expenseDate.toString(),
              style: AppTextStyle.style12400(myColor: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
