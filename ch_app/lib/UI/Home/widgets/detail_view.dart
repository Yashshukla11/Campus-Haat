import 'package:flutter/material.dart';

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
        title: Text(toTitleCase(widget.product.title)),
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toTitleCase(widget.product.title),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    capitalizeFirstWord(widget.product.info),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Price: ${widget.product.productPricing.priceText}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: ${widget.product.productPricing.quantity} ${widget.product.productPricing.unit.categoryTitle}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sold by: ${widget.product.productSoldBy.creatorName}',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.product.productSoldBy.creatorName
                                  .toLowerCase() ==
                              '(only veg)'
                          ? Colors.green
                          : Colors.black,
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

String capitalizeFirstWord(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
