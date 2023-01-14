import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatPageState();
  }
}

class _ProductCreatPageState extends State<ProductCreatePage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/img.JPG',
  };
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //working with forms

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      //autovalidate: true,
      validator: (String value) {
        //working with forms
        if (value.isEmpty || value.length < 5) {
          return "Title Required and should be 5 characters long!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Title",
      ),
      initialValue: product == null ? "" : product.title,
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildTitleDescriptionField(Product product) {
    return TextFormField(
      validator: (String value) {
        //working with forms
        if (value.isEmpty || value.length < 10) {
          return "Description is Required and should be 10+ characters long!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Description",
      ),
      initialValue: product == null ? "" : product.description,
      maxLines: 4,
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildTitlePriceField(Product product) {
    return TextFormField(
      validator: (String value) {
        //working with forms
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return "Price Required and should be a number!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Price",
      ),
      initialValue: product == null ? "" : product.price.toString(),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              child: Text('Save'),
              textColor: Colors.grey,
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductIndex),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey, //working with forms
          child: ListView(
            //Scrollable
            padding: EdgeInsets.symmetric(
                horizontal:
                    targetPadding / 2), //landscape portrait when list view
            children: <Widget>[
              _buildTitleTextField(product),
              _buildTitleDescriptionField(product),
              _buildTitlePriceField(product),
              SizedBox(height: 10.0),
              _buildSubmitButton(),

              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      //working with forms
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool sucess) {
        if (sucess) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(context: context ,builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something went wrong'),
              content: Text('Please try again!'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
