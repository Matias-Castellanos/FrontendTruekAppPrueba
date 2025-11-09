import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyWalletWidget extends StatelessWidget {
  final VoidCallback onGetStarted;

  const EmptyWalletWidget({
    super.key,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.primaryLight,
                size: 15.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Welcome to TruekCoin Wallet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'TruekCoins help balance value differences in trades and make bartering fair for everyone.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          _buildBenefitItem(
            context,
            'swap_horiz',
            'Balance Trade Values',
            'Use coins when items have different values',
          ),
          SizedBox(height: 2.h),
          _buildBenefitItem(
            context,
            'security',
            'Secure Transactions',
            'Protected by biometric authentication',
          ),
          SizedBox(height: 2.h),
          _buildBenefitItem(
            context,
            'history',
            'Track Your Trades',
            'Complete history of all transactions',
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Get Started',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () => _showTutorial(context),
            child: Text(
              'Learn More About TruekCoins',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    String iconName,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.accentLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.accentLight,
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
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTutorial(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How TruekCoins Work'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '1. Purchase TruekCoins using your preferred payment method\n\n'
                  '2. Use coins to balance value differences in trades\n\n'
                  '3. Earn coins by completing successful trades\n\n'
                  '4. Track all transactions in your wallet history\n\n'
                  '5. Secure all transactions with biometric authentication',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got It'),
            ),
          ],
        );
      },
    );
  }
}
