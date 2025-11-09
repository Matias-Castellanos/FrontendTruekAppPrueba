import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoading;
  final Function(String provider) onSocialLogin;

  const SocialLoginWidget({
    super.key,
    this.isLoading = false,
    required this.onSocialLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.dividerColor,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.dividerColor,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Column(
          children: [
            // Google Login
            _buildSocialButton(
              context: context,
              provider: 'Google',
              icon: 'g_translate',
              backgroundColor: Colors.white,
              textColor: AppTheme.lightTheme.colorScheme.onSurface,
              borderColor: AppTheme.lightTheme.dividerColor,
            ),
            SizedBox(height: 2.h),

            // Apple Login
            _buildSocialButton(
              context: context,
              provider: 'Apple',
              icon: 'apple',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              borderColor: Colors.black,
            ),
            SizedBox(height: 2.h),

            // Facebook Login
            _buildSocialButton(
              context: context,
              provider: 'Facebook',
              icon: 'facebook',
              backgroundColor: const Color(0xFF1877F2),
              textColor: Colors.white,
              borderColor: const Color(0xFF1877F2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String icon,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      height: 6.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : () => onSocialLogin(provider),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: textColor,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              'Continue with $provider',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
