import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_coins_button_widget.dart';
import './widgets/balance_card_widget.dart';
import './widgets/empty_wallet_widget.dart';
import './widgets/security_features_widget.dart';
import './widgets/transaction_history_widget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _biometricEnabled = true;
  bool _pinEnabled = false;
  bool _isNewUser = false;

  // Mock wallet data
  double _balance = 125.50;
  int _pendingTransactions = 2;
  DateTime _lastUpdate = DateTime.now().subtract(const Duration(minutes: 15));

  final List<Map<String, dynamic>> _transactions = [
    {
      "id": "tx_001",
      "type": "Trade_Completion",
      "description": "Trade with Sarah Johnson - Vintage Camera",
      "amount": 25.0,
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "Completed",
      "details": "Received 25 TruekCoins for successful trade completion",
      "tradeId": "TR_12345",
      "partnerId": "user_sarah_j"
    },
    {
      "id": "tx_002",
      "type": "Coin_Purchase",
      "description": "Purchased TruekCoins via Apple Pay",
      "amount": 100.0,
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "status": "Completed",
      "details": "Purchased 100 TruekCoins for \$25.00",
      "paymentMethod": "Apple Pay",
      "conversionRate": 4.0
    },
    {
      "id": "tx_003",
      "type": "Offer_Adjustment",
      "description": "Trade adjustment - Gaming Console",
      "amount": -15.0,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "status": "Completed",
      "details": "Used 15 TruekCoins to balance trade value difference",
      "tradeId": "TR_12340",
      "partnerId": "user_mike_r"
    },
    {
      "id": "tx_004",
      "type": "Refund",
      "description": "Trade cancellation refund",
      "amount": 20.0,
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "status": "Completed",
      "details": "Refund for cancelled trade with Alex Thompson",
      "tradeId": "TR_12338",
      "partnerId": "user_alex_t"
    },
    {
      "id": "tx_005",
      "type": "Bonus",
      "description": "First trade completion bonus",
      "amount": 10.0,
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "status": "Completed",
      "details": "Welcome bonus for completing your first trade",
      "bonusType": "welcome"
    },
    {
      "id": "tx_006",
      "type": "Trade_Completion",
      "description": "Trade with Emma Davis - Art Supplies",
      "amount": 8.5,
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "status": "Completed",
      "details": "Received 8.5 TruekCoins for successful trade completion",
      "tradeId": "TR_12335",
      "partnerId": "user_emma_d"
    },
    {
      "id": "tx_007",
      "type": "Offer_Adjustment",
      "description": "Trade adjustment - Bicycle",
      "amount": -22.0,
      "date": DateTime.now().subtract(const Duration(days: 10)),
      "status": "Processing",
      "details": "Used 22 TruekCoins to balance trade value difference",
      "tradeId": "TR_12330",
      "partnerId": "user_john_k"
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkIfNewUser();
  }

  void _checkIfNewUser() {
    // Simulate checking if user is new (no transactions and zero balance)
    setState(() {
      _isNewUser = _transactions.isEmpty && _balance == 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showAddCoinsBottomSheet,
            icon: CustomIconWidget(
              iconName: 'add_circle',
              color: AppTheme.secondaryLight,
              size: 6.w,
            ),
            tooltip: 'Add Coins',
          ),
        ],
      ),
      body: _isNewUser ? _buildNewUserView() : _buildWalletView(),
    );
  }

  Widget _buildNewUserView() {
    return SingleChildScrollView(
      child: EmptyWalletWidget(
        onGetStarted: _showAddCoinsBottomSheet,
      ),
    );
  }

  Widget _buildWalletView() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            BalanceCardWidget(
              balance: _balance,
              pendingTransactions: _pendingTransactions,
              lastUpdate: _lastUpdate,
              onRefresh: _handleRefresh,
              isLoading: _isRefreshing,
            ),
            SizedBox(height: 2.h),
            AddCoinsButtonWidget(
              onPressed: _showAddCoinsBottomSheet,
              isLoading: _isLoading,
            ),
            SizedBox(height: 3.h),
            TransactionHistoryWidget(
              transactions: _transactions,
              onRefresh: _handleRefresh,
              onTransactionTap: _showTransactionDetails,
              isLoading: _isRefreshing,
            ),
            SizedBox(height: 3.h),
            SecurityFeaturesWidget(
              biometricEnabled: _biometricEnabled,
              pinEnabled: _pinEnabled,
              onBiometricToggle: _toggleBiometric,
              onPinSetup: _setupPin,
              onSecuritySettings: _showSecuritySettings,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _lastUpdate = DateTime.now();
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddCoinsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddCoinsBottomSheet(),
    );
  }

  Widget _buildAddCoinsBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add TruekCoins',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  _buildCoinPackages(),
                  SizedBox(height: 3.h),
                  _buildPaymentMethods(),
                  SizedBox(height: 3.h),
                  _buildPurchaseButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackages() {
    final theme = Theme.of(context);
    final packages = [
      {'coins': 25, 'price': 5.0, 'popular': false},
      {'coins': 50, 'price': 10.0, 'popular': false},
      {'coins': 125, 'price': 25.0, 'popular': true},
      {'coins': 250, 'price': 50.0, 'popular': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Package',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            final isPopular = package['popular'] as bool;

            return GestureDetector(
              onTap: () => _selectPackage(package),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPopular
                        ? AppTheme.secondaryLight
                        : theme.dividerColor.withValues(alpha: 0.5),
                    width: isPopular ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    if (isPopular)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: const BoxDecoration(
                            color: AppTheme.secondaryLight,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Popular',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'account_balance_wallet',
                            color: AppTheme.accentLight,
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '${package['coins']} Coins',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${(package['price'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppTheme.secondaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildPaymentOption('Apple Pay', 'apple', true),
        SizedBox(height: 1.h),
        _buildPaymentOption('Google Pay', 'google', false),
        SizedBox(height: 1.h),
        _buildPaymentOption('Credit Card', 'credit_card', false),
      ],
    );
  }

  Widget _buildPaymentOption(String name, String iconName, bool isSelected) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryLight.withValues(alpha: 0.1)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryLight
              : theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName == 'apple'
                ? 'phone_iphone'
                : iconName == 'google'
                    ? 'android'
                    : 'credit_card',
            color: isSelected
                ? AppTheme.primaryLight
                : theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryLight
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isSelected)
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.primaryLight,
              size: 5.w,
            ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton() {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _processPurchase,
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
              iconName: 'payment',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Purchase Coins',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPackage(Map<String, dynamic> package) {
    HapticFeedback.selectionClick();
    // Handle package selection
  }

  void _processPurchase() {
    Navigator.pop(context);
    _showPurchaseConfirmation();
  }

  void _showPurchaseConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Purchase Confirmation'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package: 125 TruekCoins'),
              Text('Payment Method: Apple Pay'),
              Text('Total Cost: \$25.00'),
              SizedBox(height: 16),
              Text('Conversion Rate: 1 USD = 5 TruekCoins'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completePurchase();
              },
              child: const Text('Confirm Purchase'),
            ),
          ],
        );
      },
    );
  }

  void _completePurchase() {
    setState(() {
      _balance += 125.0;
      _lastUpdate = DateTime.now();
      _isNewUser = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Purchase completed successfully! 125 TruekCoins added to your wallet.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTransactionDetailsBottomSheet(transaction),
    );
  }

  Widget _buildTransactionDetailsBottomSheet(Map<String, dynamic> transaction) {
    final theme = Theme.of(context);
    final isPositive = (transaction['amount'] as double) > 0;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: isPositive
                                ? AppTheme.successLight.withValues(alpha: 0.1)
                                : AppTheme.errorLight.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName:
                                  isPositive ? 'add_circle' : 'remove_circle',
                              color: isPositive
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              size: 10.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${isPositive ? '+' : ''}${(transaction['amount'] as double).toStringAsFixed(2)} TruekCoins',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: isPositive
                                ? AppTheme.successLight
                                : AppTheme.errorLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          transaction['description'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildDetailRow(
                      'Transaction ID', transaction['id'] as String),
                  _buildDetailRow('Type', transaction['type'] as String),
                  _buildDetailRow('Date',
                      _formatTransactionDate(transaction['date'] as DateTime)),
                  _buildDetailRow('Status', transaction['status'] as String),
                  if (transaction['details'] != null)
                    _buildDetailRow(
                        'Details', transaction['details'] as String),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTransactionDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _toggleBiometric() {
    setState(() {
      _biometricEnabled = !_biometricEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _biometricEnabled
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _setupPin() {
    setState(() {
      _pinEnabled = !_pinEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _pinEnabled ? 'Transaction PIN enabled' : 'Transaction PIN disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSecuritySettings() {
    Navigator.pushNamed(context, '/wallet');
  }
}
