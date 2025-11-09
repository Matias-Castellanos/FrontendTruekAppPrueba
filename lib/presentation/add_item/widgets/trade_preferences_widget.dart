import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TradePreferencesWidget extends StatelessWidget {
  final bool willingToAddCoins;
  final bool localPickupOnly;
  final bool shippingAvailable;
  final Function(bool) onWillingToAddCoinsChanged;
  final Function(bool) onLocalPickupOnlyChanged;
  final Function(bool) onShippingAvailableChanged;

  const TradePreferencesWidget({
    super.key,
    required this.willingToAddCoins,
    required this.localPickupOnly,
    required this.shippingAvailable,
    required this.onWillingToAddCoinsChanged,
    required this.onLocalPickupOnlyChanged,
    required this.onShippingAvailableChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade Preferences',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        _buildPreferenceOption(
          context,
          icon: 'add_circle_outline',
          title: 'Willing to add TruekCoins',
          subtitle: 'You can add coins to balance trade value',
          value: willingToAddCoins,
          onChanged: onWillingToAddCoinsChanged,
        ),
        SizedBox(height: 2.h),
        _buildPreferenceOption(
          context,
          icon: 'location_on',
          title: 'Local pickup only',
          subtitle: 'Meet in person for item exchange',
          value: localPickupOnly,
          onChanged: onLocalPickupOnlyChanged,
        ),
        SizedBox(height: 2.h),
        _buildPreferenceOption(
          context,
          icon: 'local_shipping',
          title: 'Shipping available',
          subtitle: 'Can ship item to buyer location',
          value: shippingAvailable,
          onChanged: onShippingAvailableChanged,
        ),
      ],
    );
  }

  Widget _buildPreferenceOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
