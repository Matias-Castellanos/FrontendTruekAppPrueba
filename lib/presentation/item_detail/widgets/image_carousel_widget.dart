import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ImageCarouselWidget extends StatefulWidget {
  final List<String> images;
  final List<String> semanticLabels;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;
  final bool isFavorite;

  const ImageCarouselWidget({
    super.key,
    required this.images,
    required this.semanticLabels,
    this.onFavoriteToggle,
    this.onShare,
    this.isFavorite = false,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showFullScreenGallery() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenGallery(
          images: widget.images,
          semanticLabels: widget.semanticLabels,
          initialIndex: _currentIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Image carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _showFullScreenGallery,
                onLongPress: _showFullScreenGallery,
                child: Hero(
                  tag: 'item_image_$index',
                  child: CustomImageWidget(
                    imageUrl: widget.images[index],
                    width: double.infinity,
                    height: 35.h,
                    fit: BoxFit.cover,
                    semanticLabel: widget.semanticLabels[index],
                  ),
                ),
              );
            },
          ),

          // Page indicators
          if (widget.images.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    width: _currentIndex == index ? 3.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ),
              ),
            ),

          // Action buttons
          Positioned(
            top: 6.h,
            right: 4.w,
            child: Column(
              children: [
                // Favorite button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: widget.onFavoriteToggle,
                    icon: CustomIconWidget(
                      iconName:
                          widget.isFavorite ? 'favorite' : 'favorite_border',
                      color: widget.isFavorite ? Colors.red : Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                // Share button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: widget.onShare,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 6.h,
            left: 4.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final List<String> semanticLabels;
  final int initialIndex;

  const _FullScreenGallery({
    required this.images,
    required this.semanticLabels,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(4.w),
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: Hero(
                tag: 'item_image_$index',
                child: CustomImageWidget(
                  imageUrl: widget.images[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: widget.semanticLabels[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
