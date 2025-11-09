import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  marketplace,
  trading,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final CustomBottomBarVariant variant;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.variant = CustomBottomBarVariant.marketplace,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: _getSelectedItemColor(colorScheme),
          unselectedItemColor: _getUnselectedItemColor(colorScheme),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: _getBottomNavItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    switch (variant) {
      case CustomBottomBarVariant.marketplace:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Browse',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add Item',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ];
      case CustomBottomBarVariant.trading:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Trades',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ];
      case CustomBottomBarVariant.minimal:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
      default:
        return [];
    }
  }

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    switch (variant) {
      case CustomBottomBarVariant.marketplace:
        _handleMarketplaceNavigation(index);
        break;
      case CustomBottomBarVariant.trading:
        _handleTradingNavigation(index);
        break;
      case CustomBottomBarVariant.minimal:
        _handleMinimalNavigation(index);
        break;
    }
  }

  void _handleMarketplaceNavigation(int index) {
    // This would typically be handled by the parent widget
    // For demonstration, we'll use a basic navigation approach
    final routes = [
      '/marketplace-home',
      '/marketplace-home', // Browse is same as home with search
      '/add-item',
      '/messages',
      '/wallet',
    ];

    if (index < routes.length) {
      // Note: This is a simplified approach. In a real app, you'd want to
      // handle this navigation in the parent widget to avoid context issues
      // Navigator.pushNamed(context, routes[index]);
    }
  }

  void _handleTradingNavigation(int index) {
    final routes = [
      '/marketplace-home',
      '/marketplace-home', // Trades view
      '/messages',
      '/wallet',
    ];

    if (index < routes.length) {
      // Navigator.pushNamed(context, routes[index]);
    }
  }

  void _handleMinimalNavigation(int index) {
    final routes = [
      '/marketplace-home',
      '/add-item',
      '/wallet', // Profile/Wallet
    ];

    if (index < routes.length) {
      // Navigator.pushNamed(context, routes[index]);
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;

    return colorScheme.brightness == Brightness.light
        ? const Color(0xFFFEFEFE)
        : const Color(0xFF1A1A1A);
  }

  Color _getSelectedItemColor(ColorScheme colorScheme) {
    if (selectedItemColor != null) return selectedItemColor!;

    return colorScheme.brightness == Brightness.light
        ? const Color(0xFF2D5A3D) // Primary green
        : const Color(0xFF4A7C59); // Primary green dark
  }

  Color _getUnselectedItemColor(ColorScheme colorScheme) {
    if (unselectedItemColor != null) return unselectedItemColor!;

    return colorScheme.brightness == Brightness.light
        ? const Color(0xFF7F8C8D) // Text secondary
        : const Color(0xFFBDC3C7); // Text secondary dark
  }
}
