import 'package:get/get.dart';
import 'dart:math';

class AppController extends GetxController {
var selectedTab = 0.obs;
var selectedLocation = 'Mumbai'.obs;
var locations = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Pune', 'Hyderabad', 'Kolkata'];
var selectedFilters = <String>[].obs;
var filters = ['WiFi', 'AC', 'Food', 'Laundry', 'Gym', 'Parking', 'Security', 'TV'];
var favorites = <String>[].obs;
var bookings = <Map<String, dynamic>>[].obs;

final List<String> _imageUrls = [
'https://thumbs.dreamstime.com/b/backpackers-hostel-modern-bunk-beds-dorm-room-twelve-people-inside-79935795.jpg',
'https://st2.depositphotos.com/1104932/5330/i/950/depositphotos_53309055-stock-photo-three-level-dormitory-beds-inside.jpg',
'https://www.momondo.co.uk/rimg/kimg/b5/03/8b49974033802d76.jpg?width=968&height=607&crop=true',
'https://a.hwstatic.com/image/upload/f_auto,q_auto,t_40/propertyimages/9/95793/10.jpg',
];

final String _fallbackImageUrl =
'https://via.placeholder.com/300x200.png?text=No+Image+Available';

List<String> _getRandomImages() {
final random = Random();
final count = random.nextInt(3) + 2; // 2 to 4 images
final images = <String>[];
for (var i = 0; i < count; i++) {
images.add(_imageUrls[random.nextInt(_imageUrls.length)]);
}
return images.isNotEmpty ? images : [_fallbackImageUrl];
}

var pgList = <Map<String, dynamic>>[
{
'id': '1',
'name': 'SkyNest PG',
'description': 'Modern PG with premium amenities near city center.',
'price': 9000,
'costBreakdown': {'rent': 6500, 'maintenance': 1000, 'utilities': 1500},
'amenities': ['WiFi', 'AC', 'Food', 'Laundry', 'Security'],
'images': [],
'maintenance': true,
'rating': 4.7,
'distance': 1.8,
'location': 'Mumbai',
'isFeatured': true,
'isCommunityPick': false,
'isTrending': true,
'isDeal': false,
},
{
'id': '2',
'name': 'Urban Haven',
'description': 'Cozy hostel with vibrant community vibes.',
'price': 7500,
'costBreakdown': {'rent': 5500, 'maintenance': 1000, 'utilities': 1000},
'amenities': ['WiFi', 'Food', 'Gym', 'Parking'],
'images': [],
'maintenance': true,
'rating': 4.3,
'distance': 2.5,
'location': 'Delhi',
'isFeatured': false,
'isCommunityPick': true,
'isTrending': false,
'isDeal': true,
},
{
'id': '3',
'name': 'BlueStay Hostel',
'description': 'Affordable stay with essential amenities.',
'price': 6000,
'costBreakdown': {'rent': 4500, 'maintenance': 500, 'utilities': 1000},
'amenities': ['WiFi', 'Food', 'Laundry', 'TV'],
'images': [],
'maintenance': false,
'rating': 4.0,
'distance': 3.0,
'location': 'Bangalore',
'isFeatured': false,
'isCommunityPick': false,
'isTrending': true,
'isDeal': false,
},
{
'id': '4',
'name': 'Elite PG',
'description': 'Luxury PG with top-notch facilities.',
'price': 12000,
'costBreakdown': {'rent': 9000, 'maintenance': 1500, 'utilities': 1500},
'amenities': ['WiFi', 'AC', 'Gym', 'Parking', 'Security'],
'images': [],
'maintenance': true,
'rating': 4.9,
'distance': 1.5,
'location': 'Chennai',
'isFeatured': true,
'isCommunityPick': true,
'isTrending': true,
'isDeal': true,
},
{
'id': '5',
'name': 'CityNest',
'description': 'Convenient PG with modern facilities.',
'price': 8500,
'costBreakdown': {'rent': 6000, 'maintenance': 1000, 'utilities': 1500},
'amenities': ['WiFi', 'AC', 'Food', 'Gym'],
'images': [],
'maintenance': true,
'rating': 4.5,
'distance': 2.0,
'location': 'Pune',
'isFeatured': false,
'isCommunityPick': false,
'isTrending': false,
'isDeal': false,
},
{
'id': '6',
'name': 'StarHaven PG',
'description': 'Premium stay with excellent connectivity.',
'price': 9500,
'costBreakdown': {'rent': 7000, 'maintenance': 1000, 'utilities': 1500},
'amenities': ['WiFi', 'AC', 'Laundry', 'Parking', 'TV'],
'images': [],
'maintenance': true,
'rating': 4.6,
'distance': 2.2,
'location': 'Hyderabad',
'isFeatured': false,
'isCommunityPick': true,
'isTrending': false,
'isDeal': true,
},
{
'id': '7',
'name': 'CosmoStay',
'description': 'Stylish PG with a focus on comfort.',
'price': 8800,
'costBreakdown': {'rent': 6500, 'maintenance': 800, 'utilities': 1500},
'amenities': ['WiFi', 'Food', 'Laundry', 'Security'],
'images': [],
'maintenance': true,
'rating': 4.4,
'distance': 2.8,
'location': 'Kolkata',
'isFeatured': true,
'isCommunityPick': false,
'isTrending': true,
'isDeal': false,
},
{
'id': '8',
'name': 'GreenVibe Hostel',
'description': 'Eco-friendly hostel with a relaxed atmosphere.',
'price': 6500,
'costBreakdown': {'rent': 5000, 'maintenance': 500, 'utilities': 1000},
'amenities': ['WiFi', 'Food', 'Parking', 'TV'],
'images': [],
'maintenance': false,
'rating': 4.1,
'distance': 3.5,
'location': 'Mumbai',
'isFeatured': false,
'isCommunityPick': true,
'isTrending': false,
'isDeal': true,
},
{
'id': '9',
'name': 'PrimeNest PG',
'description': 'Luxurious stay with all modern amenities.',
'price': 11000,
'costBreakdown': {'rent': 8500, 'maintenance': 1000, 'utilities': 1500},
'amenities': ['WiFi', 'AC', 'Gym', 'Security', 'Laundry'],
'images': [],
'maintenance': true,
'rating': 4.8,
'distance': 1.2,
'location': 'Delhi',
'isFeatured': true,
'isCommunityPick': true,
'isTrending': true,
'isDeal': false,
},
{
'id': '10',
'name': 'VividStay',
'description': 'Vibrant PG with great community events.',
'price': 8000,
'costBreakdown': {'rent': 6000, 'maintenance': 1000, 'utilities': 1000},
'amenities': ['WiFi', 'Food', 'Gym', 'TV', 'Parking'],
'images': [],
'maintenance': true,
'rating': 4.2,
'distance': 2.7,
'location': 'Bangalore',
'isFeatured': false,
'isCommunityPick': false,
'isTrending': false,
'isDeal': true,
},
].obs;

@override
void onInit() {
super.onInit();
// Assign random images and ensure reactive update
final updatedPgList = pgList.map((pg) {
return {
...pg,
'images': _getRandomImages(),
};
}).toList();
pgList.assignAll(updatedPgList);
}

void changeTab(int index) {
selectedTab.value = index;
}

void changeLocation(String location) {
selectedLocation.value = location;
}

void toggleFilter(String filter) {
if (selectedFilters.contains(filter)) {
selectedFilters.remove(filter);
} else {
selectedFilters.add(filter);
}
}

void toggleFavorite(String pgId) {
if (favorites.contains(pgId)) {
favorites.remove(pgId);
} else {
favorites.add(pgId);
}
}

void addBooking(String pgId, String pgName) {
bookings.add({
'pgId': pgId,
'pgName': pgName,
'date': DateTime.now().toString(),
'status': 'Confirmed',
});
}
}