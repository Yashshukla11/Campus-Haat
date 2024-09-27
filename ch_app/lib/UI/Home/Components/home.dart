import 'package:ch_app/UI/Home/Controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/Product.dart';
import '../Controllers/home_controller.dart';
import '../widgets/cart.dart';
import '../widgets/detail_view.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'CAMPUS',
                style: TextStyle(color: Color(0xFFF2672E)),
              ),
              TextSpan(
                text: ' HAAT',
                style: TextStyle(color: Color(0xFF186CAF)),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.to(() => CartView());
                  },
                ),
                Obx(() => cartController.cartItemCount > 0
                    ? Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartController.cartItemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
              ],
            ),
          ),
        ],
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
                  borderSide: BorderSide(color: Colors.black),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value && controller.products.isEmpty) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            } else if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please try again.'),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        controller.refreshProducts();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else if (controller.filteredProducts.isEmpty) {
              return Center(child: Text('No products found'));
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    controller.loadMoreProducts();
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: controller.filteredProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.filteredProducts.length) {
                      return Obx(() => controller.isLoadingMore.value
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.black,
                            ))
                          : SizedBox.shrink());
                    }

                    final Product product = controller.filteredProducts[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            product.media.mediaUrls.first,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -12,
                                        left: 10,
                                        right: 10,
                                        child: Obx(
                                          () {
                                            int quantity = cartController
                                                    .cartItems[product] ??
                                                0;

                                            if (quantity > 0) {
                                              return Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF2C5364),
                                                      Color(0xFF203A43),
                                                      Color(0xFF0F2027),
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController
                                                            .removeFromCart(
                                                                product);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        margin: EdgeInsets.zero,
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      quantity.toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController
                                                            .addToCart(product);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        margin: EdgeInsets.zero,
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  cartController
                                                      .addToCart(product);
                                                  controller
                                                      .showTickAnimationOnAdd();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFF2C5364),
                                                        Color(0xFF203A43),
                                                        Color(0xFF0F2027),
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Add',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => DetailPage(product: product));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          toTitleCase(product.title),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '₹${product.productPricing.priceText}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index < 4
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.black,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
          Obx(() => controller.showTickAnimation.value
              ? Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: controller.tickOpacity.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }
}
