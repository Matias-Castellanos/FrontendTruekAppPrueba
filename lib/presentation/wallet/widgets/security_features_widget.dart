import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityFeaturesWidget extends StatelessWidget {
  final bool biometricEnabled;
  final bool pinEnabled;
  final VoidCallback onBiometricToggle;
  final VoidCallback onPinSetup;
  final VoidCallback onSecuritySettings;

  const SecurityFeaturesWidget({
    super.key,
    required this.biometricEnabled,
    required this.pinEnabled,
    required this.onBiometricToggle,
    required this.onPinSetup,
    required this.onSecuritySettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.primaryLight,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Security Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSecurityOption(
            context,
            'Biometric Authentication',
            'Use fingerprint or face recognition for transactions',
            'fingerprint',
            biometricEnabled,
            onBiometricToggle,
          ),
          SizedBox(height: 2.h),
          _buildSecurityOption(
            context,
            'Transaction PIN',
            'Require PIN for high-value transactions',
            'pin',
            pinEnabled,
            onPinSetup,
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onSecuritySettings,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Advanced Security Settings',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    bool isEnabled,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isEnabled
                      ? AppTheme.successLight
                      : theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (_) => onTap(),
              activeColor: AppTheme.successLight,
            ),
          ],
        ),
      ),
    );
  }
}
