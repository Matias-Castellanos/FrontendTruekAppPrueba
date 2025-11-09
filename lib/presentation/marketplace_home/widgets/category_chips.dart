import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryChips extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['name'];

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: category['icon'] as String,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(selected ? category['name'] as String : '');
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: AppTheme.primaryLight,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryLight
                    : Theme.of(context).dividerColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }
}
