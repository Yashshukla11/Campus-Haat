import 'package:get/get.dart';

import '../../../Model/Product.dart';
import '../../../Services/https.dart';

class HomeController extends GetxController {
  final HttpService _httpService = HttpService();
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final int limit = 20;
  int currentStart = 0;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final requestBody = {
        "creator": {
          "id": "6873",
          "creatorId": "298",
          "APIKey": "8e6b42f1644ecb13",
          "applicationId": "1",
          "createDate": "2024-09-15 13:15:45.8"
        },
        "campusId": "7740",
        "productCategory": {
          "selectedFilter": {"categoryId": "15"}
        },
        "productSection": "0",
        "loadType": 8,
        "limit": limit,
        "start": currentStart
      };

      final response =
          await _httpService.post('/products/productSearch', requestBody);
      final productResponse = ProductResponse.fromJson(response.data);

      if (productResponse.baseResponse.statusCode == "200") {
        List<Product> newProducts = productResponse.productsList
            .expand((category) => category.products)
            .toList();

        products.addAll(newProducts);
        currentStart += newProducts.length;

        if (newProducts.length < limit) {
          // We've reached the end of the list
          Get.snackbar('Info', 'All products loaded');
        } else {
          // There might be more products, fetch again
          fetchProducts();
        }
      } else {
        Get.snackbar('Error', productResponse.baseResponse.message);
      }
    } catch (e) {
      print('Error details: $e');
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    } finally {
      isLoading.value = false;
      filterProducts();
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  void filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(products.where((product) =>
          product.title
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          product.info
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase())));
    }
  }
}
