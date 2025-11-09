import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  primary,
  transparent,
  search,
  profile,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.primary,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onSearchTap,
    this.onProfileTap,
    this.centerTitle = false,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: _getElevation(),
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return GestureDetector(
          onTap: onSearchTap ??
              () => Navigator.pushNamed(context, '/marketplace-home'),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search items...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case CustomAppBarVariant.transparent:
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.profile:
      default:
        return title != null
            ? Text(
                title!,
                style: _getTitleTextStyle(context),
              )
            : null;
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.profile:
        return IconButton(
          onPressed:
              onProfileTap ?? () => Navigator.pushNamed(context, '/wallet'),
          icon: const Icon(Icons.account_circle_outlined),
          tooltip: 'Profile',
        );
      default:
        return automaticallyImplyLeading && Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
              )
            : null;
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    switch (variant) {
      case CustomAppBarVariant.primary:
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/messages'),
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Messages',
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/wallet'),
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: 'Wallet',
          ),
        ];
      case CustomAppBarVariant.search:
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/messages'),
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Messages',
          ),
        ];
      case CustomAppBarVariant.transparent:
        return [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, '/messages'),
              icon: const Icon(Icons.chat_bubble_outline),
              color: Colors.white,
              tooltip: 'Messages',
            ),
          ),
        ];
      case CustomAppBarVariant.profile:
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add-item'),
            icon: const Icon(Icons.add),
            tooltip: 'Add Item',
          ),
        ];
      default:
        return null;
    }
  }

  double _getElevation() {
    if (elevation != null) return elevation!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return 0;
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.profile:
      default:
        return 1;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return Colors.transparent;
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.profile:
      default:
        return colorScheme.brightness == Brightness.light
            ? const Color(0xFFFEFEFE)
            : const Color(0xFF1A1A1A);
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return Colors.white;
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.profile:
      default:
        return colorScheme.brightness == Brightness.light
            ? const Color(0xFF2C3E50)
            : const Color(0xFFECF0F1);
    }
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: _getForegroundColor(colorScheme),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
