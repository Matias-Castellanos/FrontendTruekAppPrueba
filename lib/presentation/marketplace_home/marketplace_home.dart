import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_chips.dart';
import './widgets/featured_items_carousel.dart';
import './widgets/item_grid.dart';
import './widgets/marketplace_header.dart';
import './widgets/search_bar_widget.dart';

class MarketplaceHome extends StatefulWidget {
  const MarketplaceHome({super.key});

  @override
  State<MarketplaceHome> createState() => _MarketplaceHomeState();
}

class _MarketplaceHomeState extends State<MarketplaceHome> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = '';
  bool _isRefreshing = false;
  int _currentBottomIndex = 0;

  // Mock data for featured items
  final List<Map<String, dynamic>> _featuredItems = [
    {
      "id": 1,
      "title": "Vintage Leather Jacket",
      "image":
          "https://images.unsplash.com/photo-1630287267743-9f3fb07f801c",
      "semanticLabel":
          "Brown vintage leather jacket hanging on wooden hanger against white background",
      "coins": 250,
      "distance": 2.3,
      "category": "Clothing",
      "isFavorite": false,
    },
    {
      "id": 2,
      "title": "MacBook Pro 13-inch",
      "image":
          "https://images.unsplash.com/photo-1550483513-b4fd222ce32e",
      "semanticLabel":
          "Silver MacBook Pro laptop open on white desk with coffee cup nearby",
      "coins": 800,
      "distance": 1.8,
      "category": "Electronics",
      "isFavorite": true,
    },
    {
      "id": 3,
      "title": "Acoustic Guitar",
      "image":
          "https://images.unsplash.com/photo-1650237895153-60bb982063b5",
      "semanticLabel":
          "Natural wood acoustic guitar leaning against brick wall in warm lighting",
      "coins": 180,
      "distance": 3.1,
      "category": "Music",
      "isFavorite": false,
    },
  ];

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": "apps"},
    {"name": "Electronics", "icon": "devices"},
    {"name": "Clothing", "icon": "checkroom"},
    {"name": "Books", "icon": "menu_book"},
    {"name": "Home", "icon": "home"},
    {"name": "Sports", "icon": "sports_basketball"},
    {"name": "Music", "icon": "music_note"},
    {"name": "Art", "icon": "palette"},
  ];

  // Mock data for recent listings
  final List<Map<String, dynamic>> _recentListings = [
    {
      "id": 4,
      "title": "iPhone 14 Pro",
      "image":
          "https://images.unsplash.com/photo-1605248064528-0091e98ef0a8",
      "semanticLabel":
          "Black iPhone displaying colorful app icons on home screen",
      "coins": 650,
      "distance": 0.8,
      "category": "Electronics",
      "isFavorite": false,
    },
    {
      "id": 5,
      "title": "Designer Handbag",
      "image":
          "https://images.unsplash.com/photo-1601281866896-1576541e77a1",
      "semanticLabel":
          "Elegant black leather handbag with gold chain strap on marble surface",
      "coins": 320,
      "distance": 1.5,
      "category": "Clothing",
      "isFavorite": true,
    },
    {
      "id": 6,
      "title": "Gaming Chair",
      "image":
          "https://images.unsplash.com/photo-1639240085196-23759c2e1c22",
      "semanticLabel":
          "Black and red ergonomic gaming chair with LED lighting in modern setup",
      "coins": 280,
      "distance": 2.7,
      "category": "Home",
      "isFavorite": false,
    },
    {
      "id": 7,
      "title": "Yoga Mat Set",
      "image":
          "https://images.unsplash.com/photo-1470291752804-b4a076537efe",
      "semanticLabel":
          "Purple yoga mat rolled up with water bottle and towel on wooden floor",
      "coins": 45,
      "distance": 1.2,
      "category": "Sports",
      "isFavorite": false,
    },
    {
      "id": 8,
      "title": "Coffee Table Books",
      "image":
          "https://images.unsplash.com/photo-1666204575733-cda4725fc162",
      "semanticLabel":
          "Stack of colorful hardcover books on white coffee table with plant in background",
      "coins": 75,
      "distance": 3.4,
      "category": "Books",
      "isFavorite": true,
    },
    {
      "id": 9,
      "title": "Wireless Headphones",
      "image":
          "https://images.unsplash.com/photo-1669480380822-5e72ece8ffcc",
      "semanticLabel":
          "White over-ear wireless headphones on clean white background",
      "coins": 150,
      "distance": 0.9,
      "category": "Electronics",
      "isFavorite": false,
    },
  ];

  // Mock data for nearby items
  final List<Map<String, dynamic>> _nearbyItems = [
    {
      "id": 10,
      "title": "Bicycle",
      "image":
          "https://images.unsplash.com/photo-1661027885608-54f6edcb2493",
      "semanticLabel":
          "Red mountain bike parked against brick wall on sunny day",
      "coins": 220,
      "distance": 0.3,
      "category": "Sports",
      "isFavorite": false,
    },
    {
      "id": 11,
      "title": "Kitchen Appliances",
      "image":
          "https://images.unsplash.com/photo-1721742605805-fd49926cf333",
      "semanticLabel":
          "Modern stainless steel kitchen appliances including blender and coffee maker",
      "coins": 180,
      "distance": 0.5,
      "category": "Home",
      "isFavorite": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle infinite scroll if needed
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onItemTap(Map<String, dynamic> item) {
    Navigator.pushNamed(context, '/item-detail', arguments: item);
  }

  void _onItemLongPress(Map<String, dynamic> item) {
    _showQuickActions(item);
  }

  void _showQuickActions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Save Item'),
              onTap: () {
                Navigator.pop(context);
                // Handle save
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Report'),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category == 'All' ? '' : category;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Navigate to browse/search
        break;
      case 2:
        Navigator.pushNamed(context, '/add-item');
        break;
      case 3:
        Navigator.pushNamed(context, '/messages');
        break;
      case 4:
        Navigator.pushNamed(context, '/wallet');
        break;
    }
  }

  List<Map<String, dynamic>> _getFilteredItems(
      List<Map<String, dynamic>> items) {
    if (_selectedCategory.isEmpty) return items;
    return items
        .where((item) => item['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: MarketplaceHeader(
                location: 'San Francisco, CA',
                coinBalance: 1250,
                onLocationTap: () {
                  // Handle location tap
                },
                onNotificationTap: () {
                  // Handle notification tap
                },
                onCoinBalanceTap: () {
                  Navigator.pushNamed(context, '/wallet');
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                searchController: _searchController,
                onVoiceSearch: () {
                  // Handle voice search
                },
                onSearchChanged: (value) {
                  // Handle search change
                },
                onSearchTap: () {
                  // Handle search tap
                },
              ),
            ),
            SliverToBoxAdapter(
              child: FeaturedItemsCarousel(
                featuredItems: _featuredItems,
                onItemTap: _onItemTap,
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),
            SliverToBoxAdapter(
              child: ItemGrid(
                title: 'Recent Listings',
                items: _getFilteredItems(_recentListings),
                onItemTap: _onItemTap,
                onItemLongPress: _onItemLongPress,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 2.h),
            ),
            SliverToBoxAdapter(
              child: ItemGrid(
                title: 'Near You',
                items: _getFilteredItems(_nearbyItems),
                onItemTap: _onItemTap,
                onItemLongPress: _onItemLongPress,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h), // Bottom padding for FAB
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-item');
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        tooltip: 'Add Item',
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        variant: CustomBottomBarVariant.marketplace,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
