import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onVoiceSearch;
  final Function(String) onSearchChanged;
  final VoidCallback onSearchTap;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onVoiceSearch,
    required this.onSearchChanged,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'search',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search items, categories...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: onVoiceSearch,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
