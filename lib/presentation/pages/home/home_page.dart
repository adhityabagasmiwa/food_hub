import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/presentation/misc/app_colors.dart';
import 'package:food_hub/presentation/misc/app_sizes.dart';
import 'package:food_hub/presentation/misc/app_styles.dart';
import 'package:food_hub/presentation/pages/home/home_controller.dart';
import 'package:food_hub/presentation/widgets/common_cardh_recipe.dart';
import 'package:food_hub/presentation/widgets/common_cardv_recipe.dart';
import 'package:food_hub/presentation/widgets/common_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    Widget trendingRecipesSection(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.dimen24.w),
            child: CommonText(
              text: 'Trending Recipes',
              style: textStyleW600S18.copyWith(color: Colors.black),
            ),
          ),
          SizedBox(height: AppSizes.dimen8.h),
          SizedBox(
            height: orientation == Orientation.landscape
                ? AppSizes.size300.h
                : AppSizes.size220.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controller.trendingRecipes.length,
              itemBuilder: (newContext, index) {
                var recipeData = _controller.trendingRecipes[index];

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? AppSizes.dimen24.w : AppSizes.dimen8.w,
                    right: index == _controller.trendingRecipes.length - 1
                        ? AppSizes.dimen24.w
                        : AppSizes.dimen8.w,
                  ),
                  child: CommonCardHorizontalRecipe(
                    recipeData: recipeData,
                    onTap: () {
                      _controller.navigateToRecipeDetail(
                        context: context,
                        argument: recipeData,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    Widget popularRecipesSection(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.dimen24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: 'Popular Category',
              style: textStyleW600S18.copyWith(color: Colors.black),
            ),
            SizedBox(height: AppSizes.dimen16.h),
            Wrap(
              spacing: 8,
              children: _controller.categoryRecipes
                  .map((e) => ChoiceChip(
                        label: CommonText(
                          text: e.name,
                          style: textStyleW500S12,
                        ),
                        elevation: 0.75,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: _controller.categoryIdSelected == e.id
                              ? AppColors.white
                              : AppColors.primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(AppSizes.size24),
                        ),
                        side: BorderSide.none,
                        showCheckmark: false,
                        selectedColor: AppColors.primaryColor,
                        selected: _controller.categoryIdSelected == e.id,
                        onSelected: (_) {
                          setState(() {
                            _controller.setSelectedCategory(
                              id: e.id,
                              category: e.name.toLowerCase(),
                            );
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: AppSizes.dimen16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.dimen12.h,
                mainAxisSpacing: AppSizes.dimen12.w,
                mainAxisExtent: orientation == Orientation.landscape
                    ? AppSizes.size240.h
                    : AppSizes.size190.h,
              ),
              itemCount: _controller.popularRecipes.length,
              itemBuilder: (newContext, index) {
                var recipeData = _controller.popularRecipes[index];

                return CommonCardVerticalRecipe(
                  recipeData: recipeData,
                  onTap: () {
                    _controller.navigateToRecipeDetail(
                      context: context,
                      argument: recipeData,
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    Widget searchSection({required Function()? onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.dimen48),
        child: ListTile(
          tileColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.dimen48),
          ),
          leading:
              const Icon(Icons.search, color: AppColors.textSecondaryColor),
          title: CommonText(
            text: 'Search food recipes...',
            style: textStyleW500S14.copyWith(color: AppColors.textColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.dimen24.w,
                        top: AppSizes.dimen16.h,
                        right: AppSizes.dimen24.w,
                        bottom: AppSizes.dimen24.h,
                      ),
                      child: Text(
                        'Find best recipes\nfor cooking',
                        style: textStyleW700S24.copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.dimen24.w,
                      ),
                      child: searchSection(
                        onTap: () =>
                            _controller.navigateToRecipeSearch(context),
                      ),
                    ),
                    SizedBox(height: AppSizes.dimen24.h),
                    trendingRecipesSection(context),
                    SizedBox(height: AppSizes.dimen16.h),
                    popularRecipesSection(context),
                    SizedBox(height: AppSizes.dimen16.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
