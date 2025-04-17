import 'package:demo/constants/app_images.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  bool isList = false;
  bool showOptions = false;

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

  @override
  Widget build(BuildContext context) {
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
                    children: [staggeredGrid(false), staggeredGrid(true)]))
          ],
        ),
      ),
    );
  }

  Widget filterRow() {
    return AppTextField(
      prefix: const Icon(
        Icons.search,
        color: AppColors.primaryWhite,
      ),
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

  // Widget optionsRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [],
  //   );
  // }

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
        tabs: const [
          Tab(text: "All"),
          Tab(
            text: "Bookmarks",
          )
        ],
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
          10,
          (index) => StaggeredGridTile.fit(
            crossAxisCellCount: isList ? 2 : 1,
            child: gridContainer(index, isFav),
          ),
        ),
      ),
    );
  }

  Widget gridContainer(int index, bool isFav) {
    return InkWell(
      onLongPress: () {
        setState(() {
          showOptions = true;
        });
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.dividerColor)),
            child: Text(
              index == 3
                  ? "lalalalla\n lalalallalal\n lalalallal\nlalalalla\n lalalallalal\n lalalallal\n\n\nlalalal"
                  : index == 5
                      ? "lalalalla\n lalalallalal\n lalalallal\nlalalalla\n "
                      : 'Item $index hhhhh \n hhhhh',
              style: AppTextStyle.style13400(myColor: AppColors.primaryWhite),
            ),
          ),
          !isFav
              ? Padding(
                  padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
                  child: Icon(
                    Icons.bookmark_add_outlined,
                    size: 18.sp,
                    color: AppColors.textColor.withOpacity(0.5),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
