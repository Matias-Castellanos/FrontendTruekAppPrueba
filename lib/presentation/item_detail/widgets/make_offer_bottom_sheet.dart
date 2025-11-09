import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MakeOfferBottomSheet extends StatefulWidget {
  final int itemCoinValue;
  final int userCoinBalance;
  final List<Map<String, dynamic>> userItems;
  final Function(
          int coinAmount, String? message, Map<String, dynamic>? selectedItem)?
      onSubmitOffer;

  const MakeOfferBottomSheet({
    super.key,
    required this.itemCoinValue,
    required this.userCoinBalance,
    required this.userItems,
    this.onSubmitOffer,
  });

  @override
  State<MakeOfferBottomSheet> createState() => _MakeOfferBottomSheetState();
}

class _MakeOfferBottomSheetState extends State<MakeOfferBottomSheet> {
  late double _coinAmount;
  final TextEditingController _messageController = TextEditingController();
  Map<String, dynamic>? _selectedItem;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _coinAmount = widget.itemCoinValue.toDouble();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitOffer() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate API call

      if (widget.onSubmitOffer != null) {
        widget.onSubmitOffer!(
          _coinAmount.toInt(),
          _messageController.text.trim().isEmpty
              ? null
              : _messageController.text.trim(),
          _selectedItem,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Offer submitted successfully!'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit offer. Please try again.'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAfford = _coinAmount <= widget.userCoinBalance;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.6,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Make an Offer',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coin balance info
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'account_balance_wallet',
                            color: theme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Balance',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${widget.userCoinBalance} TruekCoins',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Coin amount slider
                    Text(
                      'Offer Amount',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: canAfford
                              ? theme.colorScheme.outline.withValues(alpha: 0.2)
                              : AppTheme.errorLight,
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_coinAmount.toInt()} TruekCoins',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: canAfford
                                      ? theme.colorScheme.onSurface
                                      : AppTheme.errorLight,
                                ),
                              ),
                              if (!canAfford)
                                Text(
                                  'Insufficient balance',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.errorLight,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Slider(
                            value: _coinAmount,
                            min: (widget.itemCoinValue * 0.5).roundToDouble(),
                            max: (widget.itemCoinValue * 1.5).roundToDouble(),
                            divisions: ((widget.itemCoinValue * 1.5) -
                                    (widget.itemCoinValue * 0.5))
                                .toInt(),
                            onChanged: (value) {
                              setState(() {
                                _coinAmount = value;
                              });
                            },
                            activeColor: canAfford
                                ? theme.colorScheme.primary
                                : AppTheme.errorLight,
                            inactiveColor: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(widget.itemCoinValue * 0.5).toInt()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Suggested: ${widget.itemCoinValue}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '${(widget.itemCoinValue * 1.5).toInt()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Item selection
                    Text(
                      'Add Item from Your Inventory (Optional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    if (widget.userItems.isEmpty)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.2),
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
                                'No items in your inventory to trade',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        height: 25.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.userItems.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 3.w),
                          itemBuilder: (context, index) {
                            final item = widget.userItems[index];
                            final isSelected = _selectedItem == item;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedItem = isSelected ? null : item;
                                });
                              },
                              child: Container(
                                width: 35.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outline
                                            .withValues(alpha: 0.2),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item image
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(2.w),
                                        ),
                                        child: CustomImageWidget(
                                          imageUrl: item['image'] as String,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          semanticLabel:
                                              item['semanticLabel'] as String,
                                        ),
                                      ),
                                    ),

                                    // Item details
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'] as String,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${item['coinValue']} coins',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w500,
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
                          },
                        ),
                      ),
                    SizedBox(height: 3.h),

                    // Message field
                    Text(
                      'Message (Optional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'Add a personal message to your offer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canAfford && !_isSubmitting ? _submitOffer : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Submit Offer',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
