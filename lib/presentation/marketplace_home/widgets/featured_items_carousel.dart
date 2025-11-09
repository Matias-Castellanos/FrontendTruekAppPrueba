import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedItemsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> featuredItems;
  final Function(Map<String, dynamic>) onItemTap;

  const FeaturedItemsCarousel({
    super.key,
    required this.featuredItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Featured Items',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        CarouselSlider.builder(
          itemCount: featuredItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = featuredItems[index];
            return _buildFeaturedCard(context, item);
          },
          options: CarouselOptions(
            height: 25.h,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => onItemTap(item),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              CustomImageWidget(
                imageUrl: item['image'] as String,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
                semanticLabel: item['semanticLabel'] as String,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 2.h,
                left: 4.w,
                right: 4.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'monetization_on',
                          color: AppTheme.accentLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${item['coins']} TruekCoins',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.accentLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const Spacer(),
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: Colors.white70,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${item['distance']} mi',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 1.h,
                right: 2.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'FEATURED',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
