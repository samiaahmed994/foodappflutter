import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';
import 'package:helloworld/pages/auth.dart';
import 'package:helloworld/pages/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/products.dart';
import 'pages/products_admin.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model, //^creates the instance and pass down to every class
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            accentColor: Colors.grey,
            buttonColor: Colors.black,
            fontFamily: 'Tekton'),
        //home: AuthPage(), //'/' is a reserved name for home.
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),

          // '/products': (BuildContext context) =>
          //     ProductsPage(_model), //Products page
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminManager(_model), //manage products page
          //setting route names
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              //how you navigate to a page
              builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }
}
