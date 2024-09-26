class ProductResponse {
  final String? type;
  final BaseResponse baseResponse;
  final List<ProductCategory> productsList;

  ProductResponse({
    this.type,
    required this.baseResponse,
    required this.productsList,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      type: json['type'],
      baseResponse: BaseResponse.fromJson(json['baseResponse']),
      productsList: (json['productsList'] as List?)
              ?.map((item) => ProductCategory.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class BaseResponse {
  final int count;
  final String message;
  final String statusCode;

  BaseResponse({
    required this.count,
    required this.message,
    required this.statusCode,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      count: json['count'] ?? 0,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? '',
    );
  }
}

class ProductCategory {
  final Category category;
  final ProductSearch productSearch;
  final List<Product> products;

  ProductCategory({
    required this.category,
    required this.productSearch,
    required this.products,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      category: Category.fromJson(json['category']),
      productSearch: ProductSearch.fromJson(json['productSearch']),
      products: (json['products'] as List?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Category {
  final String categoryId;
  final String categoryTitle;

  Category({
    required this.categoryId,
    required this.categoryTitle,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
    );
  }
}

class ProductSearch {
  final String campusId;

  ProductSearch({
    required this.campusId,
  });

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    return ProductSearch(
      campusId: json['campusId'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String title;
  final String info;
  final Media media;
  final ProductPricing productPricing;
  final ProductSoldBy productSoldBy;
  final List<ProductOption> options;

  Product({
    required this.id,
    required this.title,
    required this.info,
    required this.media,
    required this.productPricing,
    required this.productSoldBy,
    required this.options,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      info: json['info'] ?? '',
      media: Media.fromJson(json['media']),
      productPricing: ProductPricing.fromJson(json['productPricing']),
      productSoldBy: ProductSoldBy.fromJson(json['productSoldBy']),
      options: (json['options'] as List?)
              ?.map((item) => ProductOption.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Media {
  final List<String> mediaUrls;

  Media({required this.mediaUrls});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
    );
  }
}

class ProductPricing {
  final double price;
  final int quantity;
  final String priceText;
  final Unit unit;

  ProductPricing({
    required this.price,
    required this.quantity,
    required this.priceText,
    required this.unit,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      priceText: json['priceText'] ?? '',
      unit: Unit.fromJson(json['unit']),
    );
  }
}

class Unit {
  final String categoryTitle;

  Unit({required this.categoryTitle});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      categoryTitle: json['categoryTitle'] ?? '',
    );
  }
}

class ProductSoldBy {
  final String creatorImageUrl;
  final String creatorName;
  final String id;

  ProductSoldBy({
    required this.creatorImageUrl,
    required this.creatorName,
    required this.id,
  });

  factory ProductSoldBy.fromJson(Map<String, dynamic> json) {
    return ProductSoldBy(
      creatorImageUrl: json['creatorImageUrl'] ?? '',
      creatorName: json['creatorName'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class ProductOption {
  final String id;
  final String title;
  final double price;

  ProductOption({
    required this.id,
    required this.title,
    required this.price,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
