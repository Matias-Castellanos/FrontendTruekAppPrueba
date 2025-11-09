import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryPickerWidget extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryPickerWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  static final List<Map<String, dynamic>> categories = [
    {
      'name': 'Electronics',
      'icon': 'devices',
      'subcategories': [
        'Phones',
        'Laptops',
        'Tablets',
        'Gaming',
        'Audio',
        'Cameras'
      ]
    },
    {
      'name': 'Clothing',
      'icon': 'checkroom',
      'subcategories': [
        'Men\'s Clothing',
        'Women\'s Clothing',
        'Shoes',
        'Accessories',
        'Bags'
      ]
    },
    {
      'name': 'Home & Garden',
      'icon': 'home',
      'subcategories': [
        'Furniture',
        'Decor',
        'Kitchen',
        'Garden',
        'Tools',
        'Appliances'
      ]
    },
    {
      'name': 'Sports & Outdoors',
      'icon': 'sports_soccer',
      'subcategories': [
        'Fitness',
        'Outdoor Gear',
        'Sports Equipment',
        'Bicycles'
      ]
    },
    {
      'name': 'Books & Media',
      'icon': 'menu_book',
      'subcategories': ['Books', 'Movies', 'Music', 'Games', 'Magazines']
    },
    {
      'name': 'Toys & Games',
      'icon': 'toys',
      'subcategories': [
        'Action Figures',
        'Board Games',
        'Educational',
        'Outdoor Toys'
      ]
    },
    {
      'name': 'Automotive',
      'icon': 'directions_car',
      'subcategories': ['Car Parts', 'Motorcycles', 'Tools', 'Accessories']
    },
    {
      'name': 'Art & Crafts',
      'icon': 'palette',
      'subcategories': [
        'Paintings',
        'Sculptures',
        'Craft Supplies',
        'Handmade Items'
      ]
    },
    {
      'name': 'Musical Instruments',
      'icon': 'music_note',
      'subcategories': ['Guitars', 'Keyboards', 'Drums', 'Wind Instruments']
    },
    {
      'name': 'Other',
      'icon': 'category',
      'subcategories': ['Miscellaneous', 'Collectibles', 'Antiques']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCategoryBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.lightTheme.dividerColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCategory ?? 'Select Category',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selectedCategory != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _CategoryBottomSheet(
          categories: categories,
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _CategoryBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final ScrollController scrollController;

  const _CategoryBottomSheet({
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
    required this.scrollController,
  });

  @override
  State<_CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<_CategoryBottomSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCategories {
    if (_searchQuery.isEmpty) return widget.categories;

    return widget.categories.where((category) {
      final categoryName = (category['name'] as String).toLowerCase();
      final subcategories = (category['subcategories'] as List<String>);
      final hasMatchingSubcategory = subcategories
          .any((sub) => sub.toLowerCase().contains(_searchQuery.toLowerCase()));

      return categoryName.contains(_searchQuery.toLowerCase()) ||
          hasMatchingSubcategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Select Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search categories...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return _buildCategoryTile(context, category);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(
      BuildContext context, Map<String, dynamic> category) {
    final categoryName = category['name'] as String;
    final isSelected = widget.selectedCategory == categoryName;

    return ExpansionTile(
      leading: CustomIconWidget(
        iconName: category['icon'] as String,
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 6.w,
      ),
      title: Text(
        categoryName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            )
          : CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
      onExpansionChanged: (expanded) {
        if (!expanded && isSelected) {
          Navigator.pop(context);
        }
      },
      children: [
        Container(
          padding: EdgeInsets.only(left: 12.w),
          child: Column(
            children:
                (category['subcategories'] as List<String>).map((subcategory) {
              return ListTile(
                title: Text(
                  subcategory,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  widget.onCategorySelected(subcategory);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        ListTile(
          leading: SizedBox(width: 6.w),
          title: Text(
            'Select "$categoryName"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          onTap: () {
            widget.onCategorySelected(categoryName);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
