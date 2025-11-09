import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TradeHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tradeHistory;

  const TradeHistoryWidget({
    super.key,
    required this.tradeHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (tradeHistory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trade History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'No similar trades found for reference',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Text(
                'Trade History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  '${tradeHistory.length} similar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Trade history list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tradeHistory.length > 3 ? 3 : tradeHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final trade = tradeHistory[index];
              return _buildTradeHistoryItem(context, trade);
            },
          ),

          // Show more button if there are more than 3 trades
          if (tradeHistory.length > 3) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () => _showAllTradeHistory(context),
                child: Text(
                  'View all ${tradeHistory.length} similar trades',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTradeHistoryItem(
      BuildContext context, Map<String, dynamic> trade) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Trade item image
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.w),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.w),
              child: CustomImageWidget(
                imageUrl: trade['itemImage'] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
                semanticLabel: trade['itemSemanticLabel'] as String,
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Trade details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trade['itemName'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'monetization_on',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 3.5.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${trade['coinValue']} TruekCoins',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatTradeDate(trade['tradeDate'] as DateTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Success indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 3.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Traded',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTradeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Today';
    }
  }

  void _showAllTradeHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Text(
                      'Similar Trade History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Full trade history list
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: tradeHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final trade = tradeHistory[index];
                    return _buildTradeHistoryItem(context, trade);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
