import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/action_buttons_widget.dart';
import './widgets/description_widget.dart';
import './widgets/image_carousel_widget.dart';
import './widgets/item_info_widget.dart';
import './widgets/make_offer_bottom_sheet.dart';
import './widgets/owner_info_widget.dart';
import './widgets/trade_history_widget.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({super.key});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  bool _isFavorite = false;
  bool _isItemAvailable = true;
  bool _isOwnerBlocked = false;
  bool _hasInsufficientCoins = false;

  // Mock data for the item
  final Map<String, dynamic> _itemData = {
    'id': 1,
    'title': 'Vintage Leather Jacket',
    'description':
        '''This is a beautiful vintage leather jacket from the 1980s. It's made of genuine leather and has been well-maintained over the years. The jacket features a classic design with multiple pockets and a comfortable fit. Perfect for anyone who loves vintage fashion or wants to add a unique piece to their wardrobe.

The jacket has some minor signs of wear that are consistent with its age, but overall it's in excellent condition. It has been stored in a smoke-free environment and comes from a pet-free home. The size is medium and fits true to size.

This would make a great addition to any fashion enthusiast's collection or could be a perfect gift for someone special. The timeless design ensures it will never go out of style.''',
    'images': [
      'https://images.pexels.com/photos/1124465/pexels-photo-1124465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1656684/pexels-photo-1656684.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    'semanticLabels': [
      'Brown vintage leather jacket hanging on wooden hanger against white background',
      'Close-up detail of leather jacket showing zipper and pocket design',
      'Side view of vintage leather jacket displaying classic cut and styling',
    ],
    'coinValue': 150,
    'condition': 'Excellent',
    'category': 'Fashion & Clothing',
    'postDate': DateTime.now().subtract(const Duration(days: 3)),
    'owner': {
      'name': 'Sarah Johnson',
      'avatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_11b715d60-1762273834012.png',
      'semanticLabel':
          'Professional headshot of a woman with shoulder-length brown hair wearing a navy blazer',
      'isVerified': true,
      'rating': 4.8,
      'totalRatings': 127,
      'joinDate': DateTime.now().subtract(const Duration(days: 365)),
    },
  };

  // Mock trade history data
  final List<Map<String, dynamic>> _tradeHistory = [
    {
      'itemName': 'Black Leather Jacket',
      'itemImage':
          'https://images.unsplash.com/photo-1588259166431-00a7e44b2712',
      'itemSemanticLabel':
          'Black leather jacket with silver zippers and buckles',
      'coinValue': 140,
      'tradeDate': DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      'itemName': 'Vintage Denim Jacket',
      'itemImage':
          'https://images.unsplash.com/photo-1709916306473-429270ca4448',
      'itemSemanticLabel':
          'Light blue vintage denim jacket with distressed details',
      'coinValue': 120,
      'tradeDate': DateTime.now().subtract(const Duration(days: 28)),
    },
    {
      'itemName': 'Brown Suede Jacket',
      'itemImage':
          'https://images.unsplash.com/photo-1589553765532-19eb2867a08a',
      'itemSemanticLabel':
          'Brown suede jacket with fringe details and western styling',
      'coinValue': 160,
      'tradeDate': DateTime.now().subtract(const Duration(days: 45)),
    },
  ];

  // Mock user data
  final Map<String, dynamic> _userData = {
    'coinBalance': 200,
    'items': [
      {
        'id': 1,
        'name': 'Vintage Watch',
        'image':
            'https://images.unsplash.com/photo-1670445562077-2b9db38a45c0',
        'semanticLabel':
            'Classic vintage wristwatch with leather strap and gold case',
        'coinValue': 80,
      },
      {
        'id': 2,
        'name': 'Designer Sunglasses',
        'image':
            'https://images.unsplash.com/photo-1606196480772-19313d06fe42',
        'semanticLabel': 'Black designer sunglasses with reflective lenses',
        'coinValue': 60,
      },
      {
        'id': 3,
        'name': 'Leather Wallet',
        'image':
            'https://images.unsplash.com/photo-1702626275356-28884b5e38a5',
        'semanticLabel': 'Brown leather bifold wallet with multiple card slots',
        'coinValue': 40,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() {
    // Simulate checking user coin balance
    final userBalance = _userData['coinBalance'] as int;
    final itemValue = _itemData['coinValue'] as int;

    setState(() {
      _hasInsufficientCoins = userBalance < itemValue;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareItem() {
    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item shared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewOwnerProfile() {
    Navigator.pushNamed(context, '/wallet'); // Placeholder navigation
  }

  void _messageOwner() {
    Navigator.pushNamed(context, '/messages');
  }

  void _makeOffer() {
    if (_hasInsufficientCoins) {
      Navigator.pushNamed(context, '/wallet');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MakeOfferBottomSheet(
        itemCoinValue: _itemData['coinValue'] as int,
        userCoinBalance: _userData['coinBalance'] as int,
        userItems: (_userData['items'] as List).cast<Map<String, dynamic>>(),
        onSubmitOffer: (coinAmount, message, selectedItem) {
          _handleOfferSubmission(coinAmount, message, selectedItem);
        },
      ),
    );
  }

  void _handleOfferSubmission(
      int coinAmount, String? message, Map<String, dynamic>? selectedItem) {
    // Simulate offer submission
    print('Offer submitted: $coinAmount coins');
    if (message != null) print('Message: $message');
    if (selectedItem != null) print('Selected item: ${selectedItem['name']}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  ImageCarouselWidget(
                    images: (_itemData['images'] as List).cast<String>(),
                    semanticLabels:
                        (_itemData['semanticLabels'] as List).cast<String>(),
                    isFavorite: _isFavorite,
                    onFavoriteToggle: _toggleFavorite,
                    onShare: _shareItem,
                  ),

                  // Item information
                  ItemInfoWidget(
                    title: _itemData['title'] as String,
                    ownerName: _itemData['owner']['name'] as String,
                    ownerAvatar: _itemData['owner']['avatar'] as String,
                    ownerSemanticLabel:
                        _itemData['owner']['semanticLabel'] as String,
                    isVerified: _itemData['owner']['isVerified'] as bool,
                    coinValue: _itemData['coinValue'] as int,
                    condition: _itemData['condition'] as String,
                    category: _itemData['category'] as String,
                    postDate: _itemData['postDate'] as DateTime,
                    onOwnerTap: _viewOwnerProfile,
                  ),

                  // Description
                  DescriptionWidget(
                    description: _itemData['description'] as String,
                  ),

                  // Trade history
                  TradeHistoryWidget(
                    tradeHistory: _tradeHistory,
                  ),

                  // Owner information
                  OwnerInfoWidget(
                    ownerName: _itemData['owner']['name'] as String,
                    ownerAvatar: _itemData['owner']['avatar'] as String,
                    ownerSemanticLabel:
                        _itemData['owner']['semanticLabel'] as String,
                    rating: _itemData['owner']['rating'] as double,
                    totalRatings: _itemData['owner']['totalRatings'] as int,
                    joinDate: _itemData['owner']['joinDate'] as DateTime,
                    isVerified: _itemData['owner']['isVerified'] as bool,
                    onViewProfile: _viewOwnerProfile,
                  ),

                  // Bottom padding for action buttons
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Action buttons (fixed at bottom)
          ActionButtonsWidget(
            onMakeOffer: _makeOffer,
            onMessageOwner: _messageOwner,
            isItemAvailable: _isItemAvailable,
            isOwnerBlocked: _isOwnerBlocked,
            hasInsufficientCoins: _hasInsufficientCoins,
          ),
        ],
      ),
    );
  }
}
