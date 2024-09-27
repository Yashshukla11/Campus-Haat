import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/Product.dart';

class CartController extends GetxController {
  var cartItems = <Product, int>{}.obs;
  var isOrderConfirmed = false.obs;

  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
  }

  void removeFromCart(Product product) {
    if (cartItems.containsKey(product)) {
      if (cartItems[product]! > 1) {
        cartItems[product] = cartItems[product]! - 1;
      } else {
        cartItems.remove(product);
      }
    }
  }

  void deleteFromCart(Product product) {
    cartItems.remove(product);
  }

  int get cartItemCount =>
      cartItems.values.fold(0, (sum, quantity) => sum + quantity);

  double get totalPrice => cartItems.entries
      .fold(0, (sum, item) => sum + item.key.productPricing.price * item.value);

  void confirmOrder() {
    cartItems.clear();
    isOrderConfirmed.value = true;

    // Show confirmation animation
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );

    // Close the dialog and navigate back to home after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close the dialog
      Get.back(); // Navigate back to home
    });
  }
}
