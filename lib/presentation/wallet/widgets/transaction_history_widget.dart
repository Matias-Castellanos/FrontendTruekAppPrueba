import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './transaction_item_widget.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback onRefresh;
  final Function(Map<String, dynamic>) onTransactionTap;
  final bool isLoading;

  const TransactionHistoryWidget({
    super.key,
    required this.transactions,
    required this.onRefresh,
    required this.onTransactionTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _showExportDialog(context),
                child: Text(
                  'Export',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? _buildLoadingState(context)
            : transactions.isEmpty
                ? _buildEmptyState(context)
                : _buildTransactionList(context),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: 30.h,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 30.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color: theme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Transactions Yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your transaction history will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionItemWidget(
            transaction: transaction,
            onTap: () => onTransactionTap(transaction),
          );
        },
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Export Transaction History',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose export format for your transaction history:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildExportOption(
                context,
                'PDF Report',
                'Complete transaction history with details',
                'picture_as_pdf',
                () => _exportAsPDF(context),
              ),
              SizedBox(height: 1.h),
              _buildExportOption(
                context,
                'CSV File',
                'Spreadsheet format for analysis',
                'table_chart',
                () => _exportAsCSV(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
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
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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

  void _exportAsPDF(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export started. Check your downloads.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportAsCSV(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV export started. Check your downloads.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
