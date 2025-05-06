import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'pg_detail_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find();
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue[300],
            floating: true,
            pinned: true,
            title: const Text(
              'Explore Stays',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search PGs or Hostels...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue[300]),
                    suffixIcon: Icon(Icons.filter_list, color: Colors.blue[300]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Implement search logic here
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Amenities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.filters
                        .map((filter) => ChoiceChip(
                      label: Text(filter),
                      selected: controller.selectedFilters.contains(filter),
                      onSelected: (selected) => controller.toggleFilter(filter),
                      selectedColor: Colors.blue[300],
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: controller.selectedFilters.contains(filter)
                            ? Colors.white
                            : Colors.grey[900],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.blue[100]!),
                      ),
                    ))
                        .toList(),
                  )),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Text(
                'Explore All Stays',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Obx(() {
            final allPgs = controller.pgList.toList();
            if (allPgs.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No stays available.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final pg = allPgs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/pg_detail', arguments: pg),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                              child: Image.network(
                                (pg['images'] as List<dynamic>).first,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pg['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${pg['cost']} /mo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue[300],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${pg['rating']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${pg['distance']} km',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
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
                  );
                },
                childCount: allPgs.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}