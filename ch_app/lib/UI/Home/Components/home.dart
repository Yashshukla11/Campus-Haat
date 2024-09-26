import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/home_controller.dart';
import '../widgets/detail_view.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Search'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.filteredProducts.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: controller.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailPage(product: product));
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Price Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                product.productPricing.priceText,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        // Image Section with Add button partially outside the image
                        Container(
                          width: 100,
                          height: 100,
                          child: Stack(
                            clipBehavior: Clip.none,
                            // Allow part of the button to be outside the image
                            children: [
                              // Image Section
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.media.mediaUrls.first,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                              // Add Button at bottom center, partially outside the image
                              Positioned(
                                bottom: -12,
                                // Move half of the button outside the image
                                left: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle the Add button tap event
                                    print(
                                        'Add button tapped for ${product.title}');
                                  },
                                  child: Container(
                                    width: 60,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
