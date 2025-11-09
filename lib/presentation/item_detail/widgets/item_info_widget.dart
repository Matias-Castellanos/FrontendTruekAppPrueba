import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ItemInfoWidget extends StatelessWidget {
  final String title;
  final String ownerName;
  final String ownerAvatar;
  final String ownerSemanticLabel;
  final bool isVerified;
  final int coinValue;
  final String condition;
  final String category;
  final DateTime postDate;
  final VoidCallback? onOwnerTap;

  const ItemInfoWidget({
    super.key,
    required this.title,
    required this.ownerName,
    required this.ownerAvatar,
    required this.ownerSemanticLabel,
    this.isVerified = false,
    required this.coinValue,
    required this.condition,
    required this.category,
    required this.postDate,
    this.onOwnerTap,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Owner info
          GestureDetector(
            onTap: onOwnerTap,
            child: Row(
              children: [
                // Owner avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: ownerAvatar,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                      semanticLabel: ownerSemanticLabel,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Owner name and verification
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              ownerName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVerified) ...[
                            SizedBox(width: 1.w),
                            CustomIconWidget(
                              iconName: 'verified',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 4.w,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'Tap to view profile',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Key details section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                // Coin value
                _buildDetailRow(
                  context,
                  'Estimated Value',
                  '$coinValue TruekCoins',
                  CustomIconWidget(
                    iconName: 'monetization_on',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                ),
                Divider(
                  height: 3.h,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Condition
                _buildDetailRow(
                  context,
                  'Condition',
                  condition,
                  CustomIconWidget(
                    iconName: 'grade',
                    color: _getConditionColor(condition),
                    size: 5.w,
                  ),
                ),
                Divider(
                  height: 3.h,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Category
                _buildDetailRow(
                  context,
                  'Category',
                  category,
                  CustomIconWidget(
                    iconName: 'category',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                Divider(
                  height: 3.h,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Posted date
                _buildDetailRow(
                  context,
                  'Posted',
                  _formatDate(postDate),
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, Widget icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        icon,
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
      case 'like new':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'good':
      case 'very good':
        return AppTheme.successLight;
      case 'fair':
      case 'acceptable':
        return AppTheme.warningLight;
      case 'poor':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
