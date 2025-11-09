import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TruekLogoWidget extends StatelessWidget {
  const TruekLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'swap_horiz',
                  color: Colors.white,
                  size: 8.w,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'T',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 6.w,
                      ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // App Name
        Text(
          'TruekApp',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: 0.5.h),

        // Tagline
        Text(
          'Trade. Barter. Discover.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
