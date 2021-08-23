import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shpownow/pages/home.dart';
import 'package:shpownow/pages/login.dart';
import 'package:shpownow/services/flutter_services/authentication.dart';
import 'package:shpownow/services/store_api.dart';

StoreProducts storeProducts = StoreProducts();

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void loadAllData() async {
    try {
      await storeProducts.initializeStoreProducts();
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (context, animation, animation2) =>
            Home(whatToLoad: 'products_page', storeProducts: storeProducts),
      ));
    } catch (e) {
      AuthObject authObject = AuthObject();
      await authObject.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
      Fluttertoast.showToast(
        msg: 'The API call was not successful/database was reset',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // void loadProducts(String productsToLoad) async {
  //   try {
  //     if (productsToLoad == 'allProducts') {
  //       await storeProducts.initializeStoreProducts();
  //     } else {
  //       await storeProducts.initializeStoreProducts();
  //       storeProducts.setTempProducts(productsToLoad);
  //     }
  //     try {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Home(
  //                     storeProducts: storeProducts,
  //                     whatToLoad: 'products_page',
  //                   )));
  //     } catch (e) {}
  //   } catch (e) {
  //     AuthObject authObject = AuthObject();
  //     await authObject.signOut();
  //     Navigator.pushReplacementNamed(context, '/login');
  //     Fluttertoast.showToast(
  //       msg: 'The API call was not successful/database was reset',
  //       toastLength: Toast.LENGTH_LONG,
  //     );
  //   }
  // }

  // void loadIndividualProduct(int productId) async {
  //   FirestoreObject firestoreObject = FirestoreObject();
  //   Map data = await storeProducts.getProductData(productId);
  //   data = await firestoreObject.getProductData(data, productId);
  //   try {
  //     Navigator.pushReplacementNamed(context, '/product', arguments: data);
  //   } catch (e) {}
  // }

  // void loadCart() async {
  //   FirestoreObject firestoreObject = FirestoreObject();
  //   List itemDataInCart = await firestoreObject.getUserCartData(storeProducts);
  //   Navigator.pushReplacementNamed(context, '/cart', arguments: {
  //     'itemDataInCart': itemDataInCart,
  //   });
  // }

  // void loadUserData() async {
  //   FirestoreObject firestoreObject = FirestoreObject();
  //   Map userData = await firestoreObject.getUserData();
  //   List purchaseData =
  //       await firestoreObject.getUserPurchasedData(storeProducts);
  //   Navigator.pushReplacementNamed(context, '/user', arguments: {
  //     'userData': userData,
  //     'purchaseData': purchaseData,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    loadAllData();

    // String whatToLoad;
    // if (ModalRoute.of(context)!.settings.arguments == null) {
    //   whatToLoad = 'home_page';
    // } else {
    //   whatToLoad =
    //       (ModalRoute.of(context)!.settings.arguments as Map)['whatToLoad'];
    // }
    // if (whatToLoad == 'home_page') {
    //   if (ModalRoute.of(context)!.settings.arguments == null) {
    //     loadProducts('allProducts');
    //   } else {
    //     loadProducts((ModalRoute.of(context)!.settings.arguments
    //         as Map)['productsToLoad']);
    //   }
    // } else if (whatToLoad == 'product_page') {
    //   int productId = (ModalRoute.of(context)!.settings.arguments as Map)['id'];
    //   loadIndividualProduct(productId);
    // } else if (whatToLoad == 'cart_page') {
    //   loadCart();
    // } else if (whatToLoad == 'user_page') {
    //   loadUserData();
    // }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/Shpownow logo.png',
                  width: 45.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  height: 30.0,
                  width: 2.0,
                  color: Colors.deepOrange[600],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Shpownow',
                  style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      fontFamily: 'Roboto',
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
            backgroundColor: Colors.deepOrange[300],
            centerTitle: true,
          ),
          body: Center(
            child: SpinKitRing(
              color: Colors.deepOrange[300] as Color,
              size: 50.0,
            ),
          )),
    );
  }
}
