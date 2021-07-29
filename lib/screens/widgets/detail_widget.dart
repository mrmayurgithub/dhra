// import 'package:dhravyatech/models/product_details.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class DetailsWidget extends StatelessWidget {
//   ProductDetails productDetails;
//   DetailsWidget({required this.productDetails});
//   @override
//   Widget build(BuildContext context) {
//     TextStyle style = TextStyle(
//       fontSize: 15,
//       height: 15,
//       letterSpacing: 1.2,
//     );
//     final List details = [
//       "Model Name - ${productDetails.modelName}",
//       "Brand - ${productDetails.brand}",
//       "Storage - ${productDetails.storage}gb",
//       "Ram - ${productDetails.ram}gb",
//       "OS - ${productDetails.os}",
//       "Color - ${productDetails.color}",
//       "Screen Size - ${productDetails.screenSize}inches",
//       "Display Type - ${productDetails.displayType}",
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SelectableText(
//           "Specifications",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w800,
//             letterSpacing: 1.2,
//           ),
//         ),
//         for (var i = 0; i < details.length; i++)
//           SelectableText(
//             details[i],
//             style: style,
//           ),
//       ],
//     );
//   }
// }
