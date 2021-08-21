// Properties of product recieved as per the website api and firebase:
// List of these maps

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
import 'package:shpownow/custom_widgets/product_cart_card.dart';
import 'package:shpownow/pages/loading.dart';
import 'package:shpownow/pages/product.dart';
import 'package:shpownow/services/custom%20classes/item_data_in_cart.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';
import 'package:shpownow/services/store_api.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();

  final ItemDataInCart itemDataInCart;
  final StoreProducts storeProducts;

  CartPage({required this.itemDataInCart, required this.storeProducts});
}

class _CartPageState extends State<CartPage> {
  bool priceVisible = false;

  @override
  Widget build(BuildContext context) {
    ItemDataInCart itemDataInCart = widget.itemDataInCart;
    List allProductData = widget.storeProducts.allProductData;
    double totalPrice = 0;

    for (int i = 0; i < itemDataInCart.data.length; i++) {
      totalPrice += itemDataInCart.data[i]['price'].toDouble() *
          itemDataInCart.data[i]['itemCount'];
    }

    totalPrice = double.parse((totalPrice).toStringAsFixed(2));

    FirestoreObject firestoreObject = FirestoreObject();

    return ListView.builder(
      itemCount: itemDataInCart.data.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            child: (Column(
              children: [
                Text(
                  'Your Cart:',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.grey[800],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            )),
          );
        } else if (index < itemDataInCart.data.length + 1) {
          int tempIndex = index - 1;
          return OpenContainer(
            closedBuilder: (context, action) {
              return ProductCartCard(
                image: itemDataInCart.data[tempIndex]['image'],
                title: itemDataInCart.data[tempIndex]['title'],
                id: itemDataInCart.data[tempIndex]['id'],
                itemCount: itemDataInCart.data[tempIndex]['itemCount'],
                price: (itemDataInCart.data[tempIndex]['price']).toDouble(),
                priceVisible: priceVisible,
                itemDataInCart: itemDataInCart,
              );
            },
            openBuilder: (context, action) {
              for (int i = 0; i < allProductData.length; i++) {
                if (allProductData[i]['id'] ==
                    itemDataInCart.data[tempIndex]['id']) {
                  return Product(
                    data: allProductData[i],
                    storeProducts: StoreProducts(),
                  );
                }
              }
              return Container(
                child: Text('Something went wrong :('),
              );
            },
          );
        } else {
          if (itemDataInCart.data.length != 0) {
            return Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: !priceVisible,
                    child: MaterialButton(
                      color: Colors.deepOrange[100],
                      child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.red[300],
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Text(
                                'Proceed to checkout',
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 2.0,
                                  color: Colors.red[300],
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )),
                      onPressed: () {
                        setState(() {
                          priceVisible = true;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: priceVisible,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.deepOrange[100],
                          width: MediaQuery.of(context).size.width,
                          height: 5.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total product price:',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '₹ $totalPrice',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tax on products (12.5%):',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '₹ ${double.parse((totalPrice * 0.125).toStringAsFixed(2))}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Delievery charges (5%):',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '₹ ${double.parse((totalPrice * 0.05).toStringAsFixed(2))}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total cost:',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '₹ ${double.parse((totalPrice * 1.175).toStringAsFixed(2))}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        MaterialButton(
                          color: Colors.blue[100],
                          child: Container(
                              margin: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    color: Colors.blue[300],
                                    size: 25.0,
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Text(
                                    'Buy now',
                                    style: TextStyle(
                                      fontSize: 23.0,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 2.0,
                                      color: Colors.blue[300],
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              )),
                          onPressed: () async {
                            bool success =
                                await firestoreObject.purchaseProductsInCart();
                            if (success) {
                              priceVisible = false;
                              Navigator.pop(context);
                              Navigator.of(context).push(PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder:
                                      (context, animation, animation2) =>
                                          Loading()));
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    backgroundColor: Color(0xff003241),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    content: Image.asset(
                                      'assets/check mark.gif',
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
                child: Text(
                  'No items in cart :(',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'Roboto',
                    letterSpacing: 2.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
