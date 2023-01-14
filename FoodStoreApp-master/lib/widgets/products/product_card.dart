import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:helloworld/widgets/products/address_tag.dart';
import 'package:helloworld/widgets/products/price_tag.dart';
import 'package:helloworld/widgets/ui_elements.dart/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(product.price.toString()), //price tag from price_tag.dart
        ],
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                //details
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[productIndex].id
                    //push will giva a bool
                    ),
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                //iconSize: ,
                //child: Text('Details'))
              ),
              SizedBox(height: 10.0),
              IconButton(
                //favorite button of a single product
                icon: Icon(model.allProducts[productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red, //Icon Color
                onPressed: () {
                  model.selectProduct(model.allProducts[productIndex].id);
                  model.toggleProductFavStatus();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          //Allows to add array of objects
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/img.JPG'),
          ), //names given at product_control
          //SizedBox(height: 10.0),
          _buildTitlePriceRow(),
          AddressTag(
              'Ape Gedara, Siri Lanka'), //address tag from address_tag.dart
          Text(product.userEmail),
          _buildButtonBar(context),
        ],
      ),
    );
  }
}
