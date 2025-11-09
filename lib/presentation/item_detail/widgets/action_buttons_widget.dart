import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onMakeOffer;
  final VoidCallback? onMessageOwner;
  final bool isItemAvailable;
  final bool isOwnerBlocked;
  final bool hasInsufficientCoins;

  const ActionButtonsWidget({
    super.key,
    this.onMakeOffer,
    this.onMessageOwner,
    this.isItemAvailable = true,
    this.isOwnerBlocked = false,
    this.hasInsufficientCoins = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _getPrimaryButtonAction(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getPrimaryButtonColor(theme),
                  foregroundColor: _getPrimaryButtonTextColor(theme),
                  padding: EdgeInsets.symmetric(vertical: 3.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _getPrimaryButtonIcon(),
                      color: _getPrimaryButtonTextColor(theme),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getPrimaryButtonText(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getPrimaryButtonTextColor(theme),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary action button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _getSecondaryButtonAction(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  side: BorderSide(
                    color: _getSecondaryButtonBorderColor(theme),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'chat_bubble_outline',
                      color: _getSecondaryButtonTextColor(theme),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Message Owner',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _getSecondaryButtonTextColor(theme),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status message if needed
            if (_shouldShowStatusMessage()) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _getStatusMessageBackgroundColor(theme),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getStatusMessageIcon(),
                      color: _getStatusMessageIconColor(theme),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _getStatusMessageText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getStatusMessageTextColor(theme),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  VoidCallback? _getPrimaryButtonAction() {
    if (!isItemAvailable || isOwnerBlocked) return null;
    return onMakeOffer;
  }

  VoidCallback? _getSecondaryButtonAction() {
    if (isOwnerBlocked) return null;
    return onMessageOwner;
  }

  Color _getPrimaryButtonColor(ThemeData theme) {
    if (!isItemAvailable) {
      return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    }
    if (isOwnerBlocked) {
      return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    }
    if (hasInsufficientCoins) {
      return AppTheme.warningLight;
    }
    return theme.colorScheme.secondary;
  }

  Color _getPrimaryButtonTextColor(ThemeData theme) {
    if (!isItemAvailable || isOwnerBlocked) {
      return theme.colorScheme.onSurfaceVariant;
    }
    return Colors.white;
  }

  String _getPrimaryButtonIcon() {
    if (!isItemAvailable) return 'block';
    if (isOwnerBlocked) return 'block';
    if (hasInsufficientCoins) return 'account_balance_wallet';
    return 'swap_horiz';
  }

  String _getPrimaryButtonText() {
    if (!isItemAvailable) return 'Item Unavailable';
    if (isOwnerBlocked) return 'Owner Blocked';
    if (hasInsufficientCoins) return 'Insufficient Coins';
    return 'Make Offer';
  }

  Color _getSecondaryButtonBorderColor(ThemeData theme) {
    if (isOwnerBlocked) {
      return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    }
    return theme.colorScheme.primary;
  }

  Color _getSecondaryButtonTextColor(ThemeData theme) {
    if (isOwnerBlocked) {
      return theme.colorScheme.onSurfaceVariant;
    }
    return theme.colorScheme.primary;
  }

  bool _shouldShowStatusMessage() {
    return hasInsufficientCoins && isItemAvailable && !isOwnerBlocked;
  }

  Color _getStatusMessageBackgroundColor(ThemeData theme) {
    return AppTheme.warningLight.withValues(alpha: 0.1);
  }

  String _getStatusMessageIcon() {
    return 'info_outline';
  }

  Color _getStatusMessageIconColor(ThemeData theme) {
    return AppTheme.warningLight;
  }

  String _getStatusMessageText() {
    return 'You need more TruekCoins to make an offer. Visit your wallet to purchase more.';
  }

  Color _getStatusMessageTextColor(ThemeData theme) {
    return AppTheme.warningLight;
  }
}
