import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DescriptionWidget extends StatefulWidget {
  final String description;

  const DescriptionWidget({
    super.key,
    required this.description,
  });

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  bool get _shouldShowExpandButton {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: 92.w - 8.w); // Account for padding
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Description text
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),

          // Expand/Collapse button
          if (_shouldShowExpandButton) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Show less' : 'Show more',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.primary,
                    size: 4.w,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
