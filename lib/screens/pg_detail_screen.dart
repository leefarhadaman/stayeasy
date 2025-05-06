import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/app_controller.dart';
import '../controllers/pg_detail_controller.dart';

class PgDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pg;

  const PgDetailScreen({Key? key, required this.pg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();
    final PgDetailController controller = Get.put(PgDetailController());
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Safely handle images list with fallback
    final images = (pg['images'] as List<dynamic>?)?.cast<String>() ?? [];
    final imagesList =
        images.isNotEmpty
            ? images
            : ['https://via.placeholder.com/300x200.png?text=No+Image'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.5,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image carousel
                  Hero(
                    tag: 'pg_${pg['id'] ?? 'unknown'}',
                    child: CarouselSlider(
                      carouselController: controller.carouselController,
                      options: CarouselOptions(
                        height: double.infinity,
                        viewportFraction: 1.0,
                        autoPlay: imagesList.length > 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 1000,
                        ),
                        autoPlayCurve: Curves.easeInOut,
                        onPageChanged: controller.updateImageIndex,
                        enlargeCenterPage: true,
                      ),
                      items:
                          imagesList
                              .map(
                                (image) => Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: screenWidth,
                                      height: screenHeight * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Image Unavailable',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  color: Colors.grey[300],
                                                ),
                                              );
                                            },
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.3),
                                                ],
                                                stops: const [0.7, 1.0],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                  // Dot indicators
                  Obx(
                    () =>
                        imagesList.length > 1
                            ? Positioned(
                              bottom: 30,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    imagesList.asMap().entries.map((entry) {
                                      final isActive =
                                          controller.currentImageIndex.value ==
                                          entry.key;
                                      return GestureDetector(
                                        onTap: () {
                                          final currentIndex =
                                              controller
                                                  .currentImageIndex
                                                  .value;
                                          final targetIndex = entry.key;
                                          if (targetIndex > currentIndex) {
                                            for (
                                              int i = currentIndex;
                                              i < targetIndex;
                                              i++
                                            ) {
                                              controller.carouselController
                                                  .nextPage(
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                  );
                                            }
                                          } else if (targetIndex <
                                              currentIndex) {
                                            for (
                                              int i = currentIndex;
                                              i > targetIndex;
                                              i--
                                            ) {
                                              controller.carouselController
                                                  .previousPage(
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                  );
                                            }
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          width: isActive ? 20 : 8,
                                          height: 8,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color:
                                                isActive
                                                    ? Colors.amber
                                                    : Colors.white.withOpacity(
                                                      0.7,
                                                    ),
                                            border:
                                                isActive
                                                    ? Border.all(
                                                      color: Colors.amberAccent,
                                                      width: 1.5,
                                                    )
                                                    : Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                    ),
                                            boxShadow:
                                                isActive
                                                    ? [
                                                      BoxShadow(
                                                        color: Colors.amber
                                                            .withOpacity(0.5),
                                                        blurRadius: 8,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                    : null,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  // Image count indicator
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(
                        () => Text(
                          '${controller.currentImageIndex.value + 1}/${imagesList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Floating card with key details
                AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pg['name'] as String? ?? 'Unknown PG',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5E8B7E),
                                        Color(0xFF8EC3B0),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '₹${pg['cost']?.toString() ?? 'N/A'} / month',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        (pg['rating'] as double?)
                                                ?.toStringAsFixed(1) ??
                                            'N/A',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey[600],
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${pg['distance']?.toString() ?? 'N/A'} km away',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Content sections
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              horizontalOffset: 50,
                              child: FadeInAnimation(child: widget),
                            ),
                        children: [
                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            pg['description'] as String? ??
                                'No description available.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Cost Breakdown
                          const Text(
                            'Cost Breakdown',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...(pg['costBreakdown'] as Map<String, dynamic>?)
                                  ?.entries
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final costEntry = entry.value;
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: SlideAnimation(
                                        verticalOffset: 20,
                                        child: FadeInAnimation(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  StringExtension(
                                                        costEntry.key,
                                                      ).capitalize ??
                                                      costEntry.key,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  '₹${costEntry.value}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF5E8B7E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                  ?.toList() ??
                              [
                                const Text(
                                  'No cost breakdown available.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                          const SizedBox(height: 24),
                          // Amenities
                          const Text(
                            'Amenities',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                (pg['amenities'] as List<dynamic>?)
                                    ?.toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final amenity = entry.value as String;
                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        child: ScaleAnimation(
                                          scale: 0.9,
                                          child: FadeInAnimation(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    const Color(
                                                      0xFFDEF5E5,
                                                    ).withOpacity(0.8),
                                                    const Color(
                                                      0xFF8EC3B0,
                                                    ).withOpacity(0.8),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _getAmenityIcon(amenity),
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    amenity,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                    ?.toList() ??
                                [
                                  const Text(
                                    'No amenities available.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                          ),
                          const SizedBox(height: 24),
                          // Maintenance
                          AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 20,
                              child: FadeInAnimation(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        pg['maintenance'] == true
                                            ? Colors.green[50]!.withOpacity(0.9)
                                            : Colors.red[50]!.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          pg['maintenance'] == true
                                              ? Colors.green[200]!.withOpacity(
                                                0.7,
                                              )
                                              : Colors.red[200]!.withOpacity(
                                                0.7,
                                              ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        pg['maintenance'] == true
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            pg['maintenance'] == true
                                                ? Colors.green[600]
                                                : Colors.red[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Maintenance: ${pg['maintenance'] == true ? 'Included' : 'Not Included'}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              pg['maintenance'] == true
                                                  ? Colors.green[600]
                                                  : Colors.red[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD700),
                                        Color(0xFFFFB300),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        appController.addBooking(
                                          pg['id'] as String,
                                          pg['name'] as String,
                                        );
                                        Get.snackbar(
                                          'Booking',
                                          'Successfully booked ${pg['name']}!',
                                          backgroundColor: const Color(
                                            0xFF5E8B7E,
                                          ),
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          margin: const EdgeInsets.all(20),
                                          borderRadius: 12,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Book Now',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF5E8B7E,
                                      ).withOpacity(0.8),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF5E8B7E,
                                        ).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Get.snackbar(
                                          'Enquiry',
                                          'Enquiry sent for ${pg['name']}!',
                                          backgroundColor: Colors.white
                                              .withOpacity(0.9),
                                          colorText: Colors.black87,
                                          snackPosition: SnackPosition.TOP,
                                          margin: const EdgeInsets.all(20),
                                          borderRadius: 12,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Enquire',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5E8B7E),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openGallery(context, imagesList);
        },
        backgroundColor: const Color(0xFF5E8B7E),
        child: const Icon(Icons.photo_library, color: Colors.white),
      ),
    );
  }

  void _openGallery(BuildContext context, List<String> images) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GalleryView(images: images)),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'food':
      case 'meals':
        return Icons.restaurant;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'gym':
        return Icons.fitness_center;
      case 'parking':
        return Icons.local_parking;
      case 'pool':
        return Icons.pool;
      case 'security':
        return Icons.security;
      default:
        return Icons.check_circle;
    }
  }
}

extension StringExtension on String {
  String get capitalize {
    return isEmpty ? this : this[0].toUpperCase() + substring(1);
  }
}

class GalleryView extends StatefulWidget {
  final List<String> images;

  const GalleryView({Key? key, required this.images}) : super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: PageStorageBucket(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Photo Gallery (${_currentIndex + 1}/${widget.images.length})',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Center(
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image Failed to Load',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final isSelected = index == _currentIndex;
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 70 : 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.amber
                                    : Colors.white.withOpacity(0.5),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            widget.images[index],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white70,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
