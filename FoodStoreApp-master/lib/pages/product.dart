import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'dart:async';
import 'package:helloworld/widgets/ui_elements.dart/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  Row _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text('Ape gedara, Siri Lanka'),
        ),
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text('|'),
        ),
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text('\$${price.toString()}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //what software back button does
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details of ' + product.title),
        ),
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img.JPG'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TitleDefault(product.title), //title from title_default.dart
              Container(
                padding: EdgeInsets.all(10.0),
                child: _buildAddressPriceRow(product.price), //Address and Price
              ),
              Text(
                product.description,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  child: Text('Delete'),
                  onPressed: () => _showWarningDialog(
                      context), //=> dammama press kroth witharai execute wenne
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
