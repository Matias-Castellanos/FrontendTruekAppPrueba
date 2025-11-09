import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = (transaction['amount'] as double) > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getTransactionColor(transaction['type'] as String)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getTransactionIcon(transaction['type'] as String),
                  color: _getTransactionColor(transaction['type'] as String),
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['description'] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatDate(transaction['date'] as DateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (transaction['status'] != null) ...[
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(transaction['status'] as String)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction['status'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              _getStatusColor(transaction['status'] as String),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isPositive ? '+' : ''}${(transaction['amount'] as double).toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isPositive
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'TruekCoins',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  String _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'trade_completion':
        return 'swap_horiz';
      case 'coin_purchase':
        return 'add_circle';
      case 'offer_adjustment':
        return 'tune';
      case 'refund':
        return 'undo';
      case 'bonus':
        return 'card_giftcard';
      case 'withdrawal':
        return 'remove_circle';
      default:
        return 'account_balance_wallet';
    }
  }

  Color _getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'trade_completion':
        return AppTheme.primaryLight;
      case 'coin_purchase':
        return AppTheme.successLight;
      case 'offer_adjustment':
        return AppTheme.warningLight;
      case 'refund':
        return AppTheme.accentLight;
      case 'bonus':
        return AppTheme.secondaryLight;
      case 'withdrawal':
        return AppTheme.errorLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'failed':
        return AppTheme.errorLight;
      case 'processing':
        return AppTheme.accentLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }
}
