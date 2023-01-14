import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import './product_card.dart';

import 'package:scoped_model/scoped_model.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    return products.length > 0
        ? ListView.builder(
            //if
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(products[index], index),
            itemCount: products.length,
          )
        : Center(child: Text("No products! Please add")); //else
  }

  Widget build(BuildContext context) {
    print("[Product Widget] Build");
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
