import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MarketplaceHeader extends StatelessWidget {
  final String location;
  final int coinBalance;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onCoinBalanceTap;

  const MarketplaceHeader({
    super.key,
    required this.location,
    required this.coinBalance,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onCoinBalanceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onLocationTap,
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          Text(
                            location,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onCoinBalanceTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'monetization_on',
                      color: AppTheme.accentLight,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '$coinBalance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: Stack(
                  children: [
                    CustomIconWidget(
                      iconName: 'notifications_outlined',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
