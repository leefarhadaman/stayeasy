import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Tab Controller
  late TabController tabController;
  final RxInt currentTabIndex = 0.obs;

  // Promotions Carousel
  final CarouselSliderController promoCarouselController =
      CarouselSliderController();
  final RxInt currentPromoIndex = 0.obs;

  // PG Card Carousels
  final Map<String, CarouselSliderController> _carouselControllers = {};
  final RxMap<String, int> currentImageIndices = <String, int>{}.obs;

  // Promotions Data
  final List<Map<String, dynamic>> promos = [
    {
      'title': 'Early Bird Discount',
      'description': 'Get 10% off on any booking made 30 days in advance',
      'color': const Color(0xFFDEF5E5),
      'icon': Icons.access_time,
      'iconColor': const Color(0xFF5E8B7E),
    },
    {
      'title': 'Student Special',
      'description': 'Special discounts for students with valid ID',
      'color': const Color(0xFFFFE5D9),
      'icon': Icons.school,
      'iconColor': const Color(0xFFFF9A76),
    },
    {
      'title': 'Long Term Stay',
      'description': 'Save up to 15% on stays longer than 6 months',
      'color': const Color(0xFFBCCEF8),
      'icon': Icons.calendar_month,
      'iconColor': const Color(0xFF5B8CFF),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    _carouselControllers.forEach((key, controller) => controller.dispose());
    _carouselControllers.clear();
    super.onClose();
  }

  CarouselSliderController getCarouselController(String pgId) {
    final String cardId = 'pg_$pgId';
    if (!_carouselControllers.containsKey(cardId)) {
      _carouselControllers[cardId] = CarouselSliderController();
    }
    return _carouselControllers[cardId]!;
  }

  void updateImageIndex(String pgId, int index) {
    final String cardId = 'pg_$pgId';
    currentImageIndices[cardId] = index;
  }

  int getCurrentImageIndex(String pgId) {
    final String cardId = 'pg_$pgId';
    return currentImageIndices[cardId] ?? 0;
  }

  void onPromoPageChanged(int index, CarouselPageChangedReason reason) {
    currentPromoIndex.value = index;
  }
}

extension on CarouselSliderController {
  void dispose() {}
}
