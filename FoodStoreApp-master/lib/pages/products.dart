import 'package:flutter/material.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:helloworld/widgets/products/products.dart';
import 'package:helloworld/widgets/ui_elements.dart/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

//Home Page

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductsPage> {
  @override
  initState() {
    //executes when the class is called
    widget.model.fetchProduct();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading:
                false, //make dissappear the hamburger icon
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No products'));
      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(onRefresh: model.fetchProduct, child: content); //pull to reload
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creates the page
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text("Food Store App"),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayFavsOnly
                  ? Icons.favorite
                  : Icons.favorite_border), //fav button
              onPressed: () {
                model.toggleDisplayMode();
              },
              color: Colors.red,
            );
          })
        ],
      ),
      body: _buildProductsList(),
    );
  }
}
