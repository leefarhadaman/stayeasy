import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/app_controller.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize HomeScreenController
    final HomeScreenController controller = Get.put(HomeScreenController());
    final AppController appController = Get.find<AppController>();
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF5E8B7E),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E8B7E), Color(0xFF8EC3B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'StayEasy',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Good morning, Alex!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Notifications',
                                      'No new notifications',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    appController.changeTab(
                                      3,
                                    ); // Navigate to profile tab
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Discover Your Next Stay',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSearchBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildPromotionsCarousel(controller),
                  const SizedBox(height: 24),
                  _buildCategoryTabs(controller),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildRecommendedGrid(appController, controller, screenWidth),
                _buildTrendingGrid(appController, controller, screenWidth),
                _buildDealsGrid(appController, controller, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed('/explore'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF5E8B7E), size: 24),
            const SizedBox(width: 10),
            Text(
              'Search for stays...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFDEF5E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: Color(0xFF5E8B7E), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionButton(
          icon: Icons.apartment,
          label: 'PG',
          color: const Color(0xFFDEF5E5),
          iconColor: const Color(0xFF5E8B7E),
          onTap: () => Get.toNamed('/explore', arguments: {'filter': 'pg'}),
        ),
        _buildQuickActionButton(
          icon: Icons.house,
          label: 'Flats',
          color: const Color(0xFFBCCEF8),
          iconColor: const Color(0xFF5B8CFF),
          onTap: () => Get.toNamed('/explore', arguments: {'filter': 'flat'}),
        ),
        _buildQuickActionButton(
          icon: Icons.hotel,
          label: 'Hostels',
          color: const Color(0xFFFFE5D9),
          iconColor: const Color(0xFFFF9A76),
          onTap: () => Get.toNamed('/explore', arguments: {'filter': 'hostel'}),
        ),
        _buildQuickActionButton(
          icon: Icons.villa,
          label: 'Villas',
          color: const Color(0xFFD8F3DC),
          iconColor: const Color(0xFF52B788),
          onTap: () => Get.toNamed('/explore', arguments: {'filter': 'villa'}),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionsCarousel(HomeScreenController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Promotions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Promotions',
                    'View all promotions feature coming soon!',
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF5E8B7E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: CarouselSlider(
              carouselController: controller.promoCarouselController,
              options: CarouselOptions(
                height: 140,
                enlargeCenterPage: true,
                viewportFraction: 0.92,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: controller.onPromoPageChanged,
              ),
              items:
                  controller.promos
                      .map((promo) => _buildPromoCard(promo))
                      .toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                controller.promos.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          controller.currentPromoIndex.value == entry.key
                              ? const Color(0xFF5E8B7E)
                              : Colors.grey[300],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> promo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: promo['color'],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(promo['icon'], size: 30, color: promo['iconColor']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  promo['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black87.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(HomeScreenController controller) {
    return Column(
      children: [
        TabBar(
          controller: controller.tabController,
          labelColor: const Color(0xFF5E8B7E),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF5E8B7E),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Recommended'),
            Tab(text: 'Trending'),
            Tab(text: 'Best Deals'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendedGrid(
    AppController appController,
    HomeScreenController controller,
    double screenWidth,
  ) {
    final recommendedPgs = appController.pgList.take(6).toList();
    if (recommendedPgs.isEmpty) {
      return _buildEmptyState('No recommendations available yet.');
    }

    return _buildResponsiveGrid(
      context: Get.context!,
      items: recommendedPgs,
      screenWidth: screenWidth,
      controller: controller,
      itemBuilder:
          (context, pg, index) =>
              _buildPgCard(context, pg, controller, appController),
    );
  }

  Widget _buildTrendingGrid(
    AppController appController,
    HomeScreenController controller,
    double screenWidth,
  ) {
    final trendingPgs =
        appController.pgList.where((pg) => pg['isTrending'] == true).toList();
    if (trendingPgs.isEmpty) {
      return _buildEmptyState('No trending stays available yet.');
    }

    return _buildResponsiveGrid(
      context: Get.context!,
      items: trendingPgs,
      screenWidth: screenWidth,
      controller: controller,
      itemBuilder:
          (context, pg, index) => _buildPgCard(
            context,
            pg,
            controller,
            appController,
            isTrending: true,
          ),
    );
  }

  Widget _buildDealsGrid(
    AppController appController,
    HomeScreenController controller,
    double screenWidth,
  ) {
    final dealPgs =
        appController.pgList.where((pg) => pg['isDeal'] == true).toList();
    if (dealPgs.isEmpty) {
      return _buildEmptyState('No deals available yet.');
    }

    return _buildResponsiveGrid(
      context: Get.context!,
      items: dealPgs,
      screenWidth: screenWidth,
      controller: controller,
      itemBuilder:
          (context, pg, index) => _buildPgCard(
            context,
            pg,
            controller,
            appController,
            isDeal: true,
          ),
    );
  }

  Widget _buildResponsiveGrid({
    required BuildContext context,
    required List<dynamic> items,
    required double screenWidth,
    required HomeScreenController controller,
    required Widget Function(BuildContext, Map<String, dynamic>, int)
    itemBuilder,
  }) {
    int crossAxisCount = 1;
    double aspectRatio = 1.5;

    if (screenWidth > 800) {
      crossAxisCount = 3;
      aspectRatio = 0.8;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
      aspectRatio = 0.85;
    } else if (screenWidth > 400) {
      crossAxisCount = 1;
      aspectRatio = 0.2;
    }

    if (crossAxisCount == 1) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              horizontalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: itemBuilder(context, items[index], index),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 600),
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: itemBuilder(context, items[index], index),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPgCard(
    BuildContext context,
    Map<String, dynamic> pg,
    HomeScreenController controller,
    AppController appController, {
    bool isTrending = false,
    bool isDeal = false,
  }) {
    final images = (pg['images'] as List<dynamic>?) ?? [];
    final imagesList =
        images.isNotEmpty
            ? images
            : ['https://via.placeholder.com/300x200.png?text=No+Image'];

    final name = pg['name'] as String? ?? 'Unknown PG';
    final location = pg['location'] as String? ?? 'Unknown Location';
    final price = pg['price']?.toString() ?? 'N/A';
    final rating = pg['rating'] as double? ?? 0.0;
    final amenities = (pg['amenities'] as List<dynamic>?) ?? [];
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth < 600 ? 280.0 : 320.0;
    final pgId = pg['id'].toString();

    final carouselController = controller.getCarouselController(pgId);

    return GestureDetector(
      onTap: () => Get.toNamed('/pg_detail', arguments: pg),
      child: Hero(
        tag: 'pg_${pg['id']}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height: cardHeight,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        controller.updateImageIndex(pgId, index);
                      },
                    ),
                    items:
                        imagesList.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () =>
                        imagesList.length > 1
                            ? Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      imagesList.asMap().entries.map((entry) {
                                        final isActive =
                                            controller.getCurrentImageIndex(
                                              pgId,
                                            ) ==
                                            entry.key;
                                        return GestureDetector(
                                          onTap:
                                              () => carouselController
                                                  .jumpToPage(entry.key),
                                          child: Container(
                                            width: isActive ? 8 : 6,
                                            height: isActive ? 8 : 6,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  isActive
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(0.5),
                                              border:
                                                  isActive
                                                      ? Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        width: 1,
                                                      )
                                                      : null,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: [
                        if (isTrending)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9A76),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Trending',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isDeal)
                          Container(
                            margin: EdgeInsets.only(left: isTrending ? 8 : 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E8B7E),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_offer,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Deal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (rating >= 4.8)
                          Container(
                            margin: EdgeInsets.only(
                              left: (isTrending || isDeal) ? 8 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Premium',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8.0,
                                        color: Colors.black,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (amenities.isNotEmpty)
                            SizedBox(
                              height: 30,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    amenities.take(4).map((amenity) {
                                      IconData iconData;
                                      switch (amenity
                                          .toString()
                                          .toLowerCase()) {
                                        case 'wifi':
                                          iconData = Icons.wifi;
                                          break;
                                        case 'ac':
                                        case 'air conditioning':
                                          iconData = Icons.ac_unit;
                                          break;
                                        case 'parking':
                                          iconData = Icons.local_parking;
                                          break;
                                        case 'gym':
                                          iconData = Icons.fitness_center;
                                          break;
                                        case 'laundry':
                                          iconData =
                                              Icons.local_laundry_service;
                                          break;
                                        case 'kitchen':
                                          iconData = Icons.kitchen;
                                          break;
                                        case 'pool':
                                          iconData = Icons.pool;
                                          iconData = Icons.pool;
                                          break;
                                        case 'food':
                                        case 'meals':
                                          iconData = Icons.restaurant;
                                          break;
                                        case 'security':
                                          iconData = Icons.security;
                                          break;
                                        default:
                                          iconData = Icons.check_circle;
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              iconData,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              amenity.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
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
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '\$$price/mo',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () => GestureDetector(
                                      onTap:
                                          () => appController.toggleFavorite(
                                            pg['id'] as String,
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              appController.favorites.contains(
                                                    pg['id'],
                                                  )
                                                  ? Colors.red.withOpacity(0.8)
                                                  : Colors.white.withOpacity(
                                                    0.2,
                                                  ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          appController.favorites.contains(
                                                pg['id'],
                                              )
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Share.share(
                                        'Check out $name on StayEasy! Price: \$$price/mo\nLocation: $location',
                                        subject: 'Check out this stay!',
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
