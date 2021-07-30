import 'package:dhravyatech/constants.dart';
import 'package:dhravyatech/screens/widgets/detail_item.dart';
import 'package:dhravyatech/screens/widgets/detail_name.dart';
import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow({
    Key? key,
    required int currentPage,
  })  : _currentPage = currentPage,
        super(key: key);

  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailName("Model Name -"),
            DetailName("Brand -"),
            DetailName("Storage -"),
            DetailName("Ram -"),
            DetailName("OS -"),
            DetailName("Color -"),
            DetailName("Screen Size -"),
            DetailName("Display Type -"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DetailItem("${productWidgets[_currentPage].modelName}"),
            DetailItem("${productWidgets[_currentPage].brand}"),
            DetailItem("${productWidgets[_currentPage].storage} GB"),
            DetailItem("${productWidgets[_currentPage].ram} GB"),
            DetailItem("${productWidgets[_currentPage].os}"),
            DetailItem("${productWidgets[_currentPage].color}"),
            DetailItem("${productWidgets[_currentPage].screenSize} Inches"),
            DetailItem("${productWidgets[_currentPage].displayType}"),
          ],
        )
      ],
    );
  }
}
