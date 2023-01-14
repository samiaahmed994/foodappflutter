//Not Using

import 'package:flutter/material.dart';
import './product_control.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    print("ProjectManager Build");
    return Column(
      children: [
         //scrollable
      ],
    );
  }
}
