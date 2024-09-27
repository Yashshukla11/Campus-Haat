import 'package:get/get.dart';

import '../../../Model/Product.dart';
import '../../../Services/https.dart';

class HomeController extends GetxController {
  final HttpService _httpService = HttpService();
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final int limit = 7;
  int currentStart = 0;
  final RxString searchQuery = ''.obs;
  final RxBool hasMoreProducts = true.obs;

  // Properties for tick animation
  final RxBool showTickAnimation = false.obs;
  final RxDouble tickOpacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (!hasMoreProducts.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;

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
          hasMoreProducts.value = false;
        }
      } else {
        hasError.value = true;
        Get.snackbar('Error', productResponse.baseResponse.message);
      }
    } catch (e) {
      hasError.value = true;
      print('Error details: $e');
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    } finally {
      isLoading.value = false;
      filterProducts();
    }
  }

  void loadMoreProducts() {
    if (!isLoadingMore.value && hasMoreProducts.value) {
      isLoadingMore.value = true;
      fetchProducts().then((_) {
        isLoadingMore.value = false;
      });
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

  void showTickAnimationOnAdd() {
    showTickAnimation.value = true;
    tickOpacity.value = 1.0;
    Future.delayed(Duration(milliseconds: 1000), () {
      tickOpacity.value = 0.0;
      Future.delayed(Duration(milliseconds: 500), () {
        showTickAnimation.value = false;
      });
    });
  }

  void refreshProducts() {
    products.clear();
    filteredProducts.clear();
    currentStart = 0;
    hasMoreProducts.value = true;
    fetchProducts();
  }
}
