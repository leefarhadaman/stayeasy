import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class PgDetailController extends GetxController {
  final RxInt currentImageIndex = 0.obs;
  final CarouselSliderController carouselController = CarouselSliderController();

  void updateImageIndex(int index, CarouselPageChangedReason reason) {
    currentImageIndex.value = index;
  }
}