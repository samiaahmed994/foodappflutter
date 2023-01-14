import 'package:flutter/material.dart';
import 'package:helloworld/pages/product_create.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

//Product List Tab

class ProductListPage extends StatefulWidget {

  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}
class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProduct();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
        return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(model.allProducts[index].id);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return ProductCreatePage();
              }),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(model.allProducts[index].title),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              model.selectProduct(model.allProducts[index].id);
              model.deleteProduct();
            } else if (direction == DismissDirection.startToEnd) {
              print('Swiped start to end');
            } else {
              print('other swiping');
            }
          },
          background: Container(
            color: Colors.grey,
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(model.allProducts[index].image),
                ),
                title: Text(model.allProducts[index].title),
                subtitle: Text('\$${model.allProducts[index].price.toString()}'),
                trailing: _buildEditButton(context, index, model),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: model.allProducts.length,
    );
      },
    ); 
  }

//Manage Products => My Products
}
