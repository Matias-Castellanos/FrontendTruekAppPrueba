import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class ConversationItemWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onMute;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onMarkRead,
    this.onArchive,
    this.onDelete,
    this.onMute,
    this.onBlock,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTradeInProgress =
        conversation['isTradeInProgress'] as bool? ?? false;
    final unreadCount = conversation['unreadCount'] as int? ?? 0;
    final isRead = unreadCount == 0;
    final timestamp = conversation['timestamp'] as DateTime?;
    final lastMessage = conversation['lastMessage'] as String? ?? '';
    final contactName = conversation['contactName'] as String? ?? '';
    final avatar = conversation['avatar'] as String? ?? '';
    final semanticLabel = conversation['semanticLabel'] as String? ?? '';

    return Slidable(
      key: ValueKey(conversation['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onMarkRead?.call(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: isRead ? Icons.mark_email_unread : Icons.mark_email_read,
            label: isRead ? 'Unread' : 'Read',
          ),
          SlidableAction(
            onPressed: (_) => onArchive?.call(),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: AppTheme.errorLight,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.transparent
                : theme.colorScheme.primary.withValues(alpha: 0.05),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 6.w,
                    backgroundColor: theme.colorScheme.surface,
                    child: avatar.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: avatar,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                            semanticLabel: semanticLabel,
                          )
                        : CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 6.w,
                          ),
                  ),
                  if (!isRead)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 3.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contactName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  isRead ? FontWeight.w500 : FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isTradeInProgress)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.successLight,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              'Trade in Progress',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isRead
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  isRead ? FontWeight.w400 : FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (timestamp != null)
                              Text(
                                _formatTimestamp(timestamp),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            if (unreadCount > 0) ...[
                              SizedBox(height: 0.5.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.5.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 4.w,
                                  minHeight: 4.w,
                                ),
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              context,
              icon: conversation['unreadCount'] == 0
                  ? 'mark_email_unread'
                  : 'mark_email_read',
              title: conversation['unreadCount'] == 0
                  ? 'Mark as Unread'
                  : 'Mark as Read',
              onTap: () {
                Navigator.pop(context);
                onMarkRead?.call();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'archive',
              title: 'Archive',
              onTap: () {
                Navigator.pop(context);
                onArchive?.call();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'volume_off',
              title: 'Mute',
              onTap: () {
                Navigator.pop(context);
                onMute?.call();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'block',
              title: 'Block User',
              onTap: () {
                Navigator.pop(context);
                onBlock?.call();
              },
              isDestructive: true,
            ),
            _buildContextMenuItem(
              context,
              icon: 'report',
              title: 'Report',
              onTap: () {
                Navigator.pop(context);
                onReport?.call();
              },
              isDestructive: true,
            ),
            _buildContextMenuItem(
              context,
              icon: 'delete',
              title: 'Delete',
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color:
            isDestructive ? AppTheme.errorLight : theme.colorScheme.onSurface,
        size: 5.w,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color:
              isDestructive ? AppTheme.errorLight : theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[timestamp.weekday - 1];
    } else {
      // Older - show date
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
    }
  }
}