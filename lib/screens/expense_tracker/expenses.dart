import 'package:demo/data/models/expense.dart';
import 'package:demo/data/providers/expense_provider.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Expenses extends ConsumerStatefulWidget {
  const Expenses({super.key});

  @override
  ConsumerState<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends ConsumerState<Expenses> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesNotifierProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    List<Expense> filteredExpenses = expenses.when(
      data: (items) {
        final todays = items
            .where((e) => isSameDate(e.expenseDate, selectedDate))
            .toList();
        if (todays.isNotEmpty) return todays;

        // fallback to yesterday
        return items
            .where((e) => isSameDate(
                e.expenseDate, selectedDate.subtract(const Duration(days: 1))))
            .toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.add, color: AppColors.primaryBlack),
        onPressed: () => AppNavigator.goToCreateExpense(context),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          children: [
            40.height,
            filterRow(ref),
            10.height,
            statsContainer(filteredExpenses),
            15.height,
            Expanded(
              child: filteredExpenses.isEmpty
                  ? Center(
                      child: Text("No expenses found",
                          style: AppTextStyle.style14400(
                              myColor: AppColors.textColor)))
                  : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: expenseItem(filteredExpenses[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterRow(WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: searchController,
            hintText: "Search expenses",
            prefix: const Icon(Icons.search, color: AppColors.primaryWhite),
          ),
        ),
        10.width,
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: ref.context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              ref.read(selectedDateProvider.notifier).state = picked;
            }
          },
          child: Row(
            children: [
              const Icon(Icons.calendar_today,
                  color: AppColors.primaryWhite, size: 20),
              5.width,
              Text(
                DateFormat("dd MMM").format(selectedDate),
                style: AppTextStyle.style12400(myColor: AppColors.textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget statsContainer(List<Expense> expenses) {
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    return Container(
      height: 120.h,
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Spent",
              style: AppTextStyle.style12400(myColor: AppColors.primaryWhite)),
          8.height,
          Text("Rs. ${total.toStringAsFixed(2)}",
              style: AppTextStyle.style18600(myColor: AppColors.errorColor)),
        ],
      ),
    );
  }

  Widget expenseItem(Expense e) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(12.w),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(e.title ?? "Untitled",
            style: AppTextStyle.style14400(myColor: AppColors.textColor)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (e.description?.isNotEmpty ?? false)
              Text(
                e.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.style12400(myColor: AppColors.textColor),
              ),
            4.height,
            Row(
              children: [
                if (e.category != null)
                  Text(
                    e.category!.name,
                    style:
                        AppTextStyle.style11400(myColor: AppColors.textColor),
                  ),
                10.width,
                Text(
                  DateFormat("dd MMM yyyy").format(e.expenseDate),
                  style: AppTextStyle.style11400(myColor: AppColors.textColor),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹ ${e.amount.toStringAsFixed(2)}",
              style: AppTextStyle.style14500(myColor: AppColors.textColor),
            ),
            if (e.isRecurring)
              const Icon(Icons.repeat, size: 16, color: AppColors.textColor),
            if (e.hasAttachments)
              const Icon(Icons.attachment,
                  size: 16, color: AppColors.textColor),
          ],
        ),
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
