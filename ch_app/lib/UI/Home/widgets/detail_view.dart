import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/Product.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({required this.product});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? selectedOptionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Container(
              height: 250,
              child: PageView.builder(
                itemCount: widget.product.media.mediaUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.product.media.mediaUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.info,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Price: ${widget.product.productPricing.priceText}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: ${widget.product.productPricing.quantity} ${widget.product.productPricing.unit.categoryTitle}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sold by: ${widget.product.productSoldBy.creatorName}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Options with radio buttons
                  if (widget.product.options.isNotEmpty) ...[
                    Text(
                      'Options:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...widget.product.options
                        .map((option) => RadioListTile<String>(
                              title: Text(
                                  '${option.title} - \$${option.price.toStringAsFixed(2)}'),
                              value: option.id,
                              groupValue: selectedOptionId,
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionId = value;
                                });
                              },
                            ))
                        .toList(),
                  ],
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle add to cart or buy action
                      Get.snackbar('Action', 'Added to cart');
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
