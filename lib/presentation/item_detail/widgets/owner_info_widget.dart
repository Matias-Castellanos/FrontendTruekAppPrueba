import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class OwnerInfoWidget extends StatelessWidget {
  final String ownerName;
  final String ownerAvatar;
  final String ownerSemanticLabel;
  final double rating;
  final int totalRatings;
  final DateTime joinDate;
  final bool isVerified;
  final VoidCallback? onViewProfile;

  const OwnerInfoWidget({
    super.key,
    required this.ownerName,
    required this.ownerAvatar,
    required this.ownerSemanticLabel,
    required this.rating,
    required this.totalRatings,
    required this.joinDate,
    this.isVerified = false,
    this.onViewProfile,
  });

  String _formatJoinDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Member for ${years} year${years == 1 ? '' : 's'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Member for ${months} month${months == 1 ? '' : 's'}';
    } else {
      return 'New member';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Owner Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),

          // Owner details
          Row(
            children: [
              // Owner avatar
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: ownerAvatar,
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.cover,
                    semanticLabel: ownerSemanticLabel,
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Owner info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and verification
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ownerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
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
                            size: 5.w,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < rating.floor()
                                  ? 'star'
                                  : 'star_border',
                              color: index < rating.floor()
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : theme.colorScheme.onSurfaceVariant,
                              size: 4.w,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${rating.toStringAsFixed(1)} (${totalRatings})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),

                    // Join date
                    Text(
                      _formatJoinDate(joinDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // View profile button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewProfile,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                side: BorderSide(
                  color: theme.colorScheme.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'View Profile',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
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
}
