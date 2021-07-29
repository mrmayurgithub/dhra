import 'package:dhravyatech/models/product_details.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageWidget extends StatelessWidget {
  ProductDetails productDetails;
  ImageWidget({required this.productDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        productDetails.url,
        height: 100,
      ),
    );
  }
}
