// Properties of product recieved as per the website api and firebase: (allProductData)
// List of maps containing following fields

// id - int
// title - String
// description - String
// category - String
// image - String linking to the image of the product
// price - double
// rating - double
// review_count - int
// reviews - List of Map{'rating' - int, 'review_text' - String, 'username' - String}
// username - String
// uid - String
// itemCount - int

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shpownow/pages/cart.dart';
import 'package:shpownow/pages/products_page.dart';
import 'package:shpownow/pages/user_info.dart';
import 'package:shpownow/services/custom%20classes/item_data_in_cart.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';
import 'package:shpownow/services/store_api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  final String whatToLoad;
  final StoreProducts storeProducts;
  Home({required this.whatToLoad, required this.storeProducts});
}

class _HomeState extends State<Home> {
  String whatToLoad = "";
  ItemDataInCart itemDataInCart = ItemDataInCart(data: null);
  List purchaseData = [];
  Map userData = {};
  StoreProducts updatedStoreProducts = StoreProducts();
  StoreProducts storeProducts = StoreProducts();
  bool leftToRight = true;

  @override
  Widget build(BuildContext context) {
    if (whatToLoad == "") {
      whatToLoad = widget.whatToLoad;
    }
    if (storeProducts.allProductData.length == 0) {
      storeProducts = widget.storeProducts;
    }
    if (updatedStoreProducts.allProductData.length != 0) {
      updatedStoreProducts.productsToLoad.value =
          storeProducts.productsToLoad.value;
      storeProducts = updatedStoreProducts;
    }

    return WillPopScope(
      onWillPop: () async {
        if (whatToLoad == 'products_page') {
          final value = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Text(
                    'Confirm action',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to exit the application?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Yes, exit application',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
          return value == true;
        } else {
          setState(() {
            leftToRight = !leftToRight;
            whatToLoad = 'products_page';
          });
          return false;
        }
      },
      child: GestureDetector(
        //try at handling swiping gesture

        // onPanUpdate: (details) async {
        //   int sensitivity = 8;
        //   if (details.delta.dx > sensitivity) {
        //     if (whatToLoad == 'products_page') {
        //       FirestoreObject firestoreObject = FirestoreObject();
        //       userData = await firestoreObject.getUserData();
        //       purchaseData =
        //           await firestoreObject.getUserPurchasedData(storeProducts);
        //       setState(() {
        //         whatToLoad = 'user_page';
        //         leftToRight = true;
        //       });
        //     } else if (whatToLoad == 'cart_page') {
        //       setState(() {
        //         whatToLoad = 'products_page';
        //         leftToRight = !leftToRight;
        //       });
        //     }
        //   }
        //   if (details.delta.dx < sensitivity) {
        //     if (whatToLoad == 'products_page') {
        //       FirestoreObject firestoreObject = FirestoreObject();
        //       itemDataInCart.data =
        //           await firestoreObject.getUserCartData(storeProducts);
        //       itemDataInCart.length.value = itemDataInCart.data.length;
        //       setState(() {
        //         whatToLoad = 'cart_page';
        //         leftToRight = false;
        //       });
        //     } else if (whatToLoad == 'user_page') {
        //       setState(() {
        //         whatToLoad = 'products_page';
        //         leftToRight = !leftToRight;
        //       });
        //     }
        //   }
        // },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey[800],
                  ),
                  onPressed: () async {
                    FirestoreObject firestoreObject = FirestoreObject();
                    userData = await firestoreObject.getUserData();
                    purchaseData = await firestoreObject
                        .getUserPurchasedData(storeProducts);
                    setState(() {
                      whatToLoad = 'user_page';
                      leftToRight = true;
                    });
                  },
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
                MaterialButton(
                  child: Text(
                    'Shpownow',
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontFamily: 'Roboto',
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    setState(() {
                      whatToLoad = 'products_page';
                      leftToRight = !leftToRight;
                    });
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.grey[800],
                        size: 25.0,
                      ),
                      onPressed: () async {
                        FirestoreObject firestoreObject = FirestoreObject();
                        itemDataInCart.data = await firestoreObject
                            .getUserCartData(storeProducts);
                        itemDataInCart.length.value =
                            itemDataInCart.data.length;
                        setState(() {
                          whatToLoad = 'cart_page';
                          leftToRight = false;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.deepOrange[300],
            centerTitle: true,
          ),
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            reverse: leftToRight,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal);
            },
            child: whatToLoad == "products_page"
                ? Container(
                    child: RefreshIndicator(
                      strokeWidth: 3.0,
                      color: Colors.deepOrangeAccent,
                      onRefresh: () async {
                        StoreProducts newStoreProducts = StoreProducts();
                        await newStoreProducts.initializeStoreProducts();
                        await newStoreProducts.checkIfProductsInitialized();
                        setState(() {
                          updatedStoreProducts = newStoreProducts;
                        });
                      },
                      child: ValueListenableBuilder(
                        valueListenable: storeProducts.productsToLoad,
                        builder: (context, value, widget) {
                          storeProducts.setTempProducts(
                              storeProducts.productsToLoad.value);
                          return ProductsPage(
                            storeProducts: storeProducts,
                          );
                        },
                        child: ProductsPage(
                          storeProducts: storeProducts,
                        ),
                      ),
                    ),
                  )
                : whatToLoad == 'cart_page'
                    ? ValueListenableBuilder(
                        valueListenable: itemDataInCart.length,
                        builder: (context, value, widget) {
                          return CartPage(
                            itemDataInCart: itemDataInCart,
                            storeProducts: storeProducts,
                          );
                        },
                      )
                    : UserInfoPage(
                        userData: userData,
                        purchaseData: purchaseData,
                        allProductData: storeProducts.allProductData,
                      ),
          ),
        ),
      ),
    );
  }
}
