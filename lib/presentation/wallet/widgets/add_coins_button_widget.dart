import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddCoinsButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const AddCoinsButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryLight,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'add_circle',
                    color: Colors.white,
                    size: 5.w,
                  ),
            SizedBox(width: 2.w),
            Text(
              isLoading ? 'Processing...' : 'Add Coins',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
