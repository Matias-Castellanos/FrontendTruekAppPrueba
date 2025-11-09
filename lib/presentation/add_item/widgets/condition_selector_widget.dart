import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConditionSelectorWidget extends StatelessWidget {
  final String? selectedCondition;
  final Function(String) onConditionSelected;

  const ConditionSelectorWidget({
    super.key,
    this.selectedCondition,
    required this.onConditionSelected,
  });

  static final List<Map<String, dynamic>> conditions = [
    {
      'name': 'New',
      'description': 'Brand new, never used',
      'icon': 'new_releases',
      'color': Color(0xFF27AE60),
    },
    {
      'name': 'Like New',
      'description': 'Excellent condition, barely used',
      'icon': 'star',
      'color': Color(0xFF2ECC71),
    },
    {
      'name': 'Good',
      'description': 'Minor signs of wear, fully functional',
      'icon': 'thumb_up',
      'color': Color(0xFFF39C12),
    },
    {
      'name': 'Fair',
      'description': 'Noticeable wear, but works well',
      'icon': 'info',
      'color': Color(0xFFE67E22),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condition',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        ...conditions
            .map((condition) => _buildConditionOption(context, condition)),
      ],
    );
  }

  Widget _buildConditionOption(
      BuildContext context, Map<String, dynamic> condition) {
    final conditionName = condition['name'] as String;
    final isSelected = selectedCondition == conditionName;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () => onConditionSelected(conditionName),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (condition['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: condition['icon'] as String,
                  color: condition['color'] as Color,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conditionName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      condition['description'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
