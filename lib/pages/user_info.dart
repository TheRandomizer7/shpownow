import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shpownow/custom_widgets/product_cart_card.dart';
import 'package:shpownow/pages/login.dart';
import 'package:shpownow/pages/product.dart';
import 'package:shpownow/services/custom%20classes/item_data_in_cart.dart';
import 'package:shpownow/services/flutter_services/authentication.dart';
import 'package:shpownow/services/store_api.dart';

class UserInfoPage extends StatefulWidget {
  _UserInfoPageState createState() => _UserInfoPageState();

  final Map userData;
  final List purchaseData;
  final List allProductData;

  UserInfoPage(
      {required this.userData,
      required this.purchaseData,
      required this.allProductData});
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    Map userData = widget.userData;
    List purchaseData = widget.purchaseData;
    List allProductData = widget.allProductData;

    int totalItemCount = 0;
    List itemCounts = [];
    for (int i = 0; i < purchaseData.length; i++) {
      totalItemCount += purchaseData[i]['purchasedItems'].length as int;
      totalItemCount += 1;
      itemCounts.add(totalItemCount);
    }

    return Container(
      child: ListView.builder(
        itemCount: totalItemCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            String purchaseString = purchaseData.length > 0
                ? "Purchased items:"
                : "No items purchased :(";
            String dateOfPurchase;
            dateOfPurchase = purchaseData.length == 0
                ? ''
                : '${DateFormat.yMEd().add_jm().format(DateTime.parse(purchaseData[0]['dateOfPurchase'].toDate().toString()))}';
            return Padding(
              padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.grey[800],
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.grey[800],
                            letterSpacing: 2.0,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'Number of purchases:',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.grey[800],
                          letterSpacing: 2.0,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '${userData['no_of_purchases']}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.grey[800],
                          letterSpacing: 2.0,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: MaterialButton(
                      color: Colors.deepOrange[100],
                      child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red[300],
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Text(
                                'Sign out',
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
                      onPressed: () async {
                        await showModal(
                            configuration: FadeScaleTransitionConfiguration(
                              transitionDuration: Duration(milliseconds: 300),
                            ),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                title: Text(
                                  'Confirm action',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to sign out?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Yes, sign out',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    onPressed: () async {
                                      AuthObject authObject = AuthObject();
                                      bool success = await authObject.signOut();
                                      if (success) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      }
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
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 3.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.deepOrange[400],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    purchaseString,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.grey[600],
                      letterSpacing: 2.0,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateOfPurchase,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            );
          } else {
            int tempIndex = index - 1;
            int count = 0;
            for (int i = 0; i < itemCounts.length; i++) {
              if (tempIndex < itemCounts[i]) {
                break;
              } else {
                count += 1;
              }
            }

            List purchasedItems = purchaseData[count]['purchasedItems'];

            int itemIndex = 0;
            if (count == 0) {
              itemIndex = tempIndex;
            } else {
              itemIndex = tempIndex - itemCounts[count - 1] as int;
            }

            int itemIndexOfSeperator = 0;
            if (count == 0) {
              itemIndexOfSeperator = itemCounts[count] - 1;
            } else {
              itemIndexOfSeperator =
                  itemCounts[count] - itemCounts[count - 1] - 1;
            }

            if (itemIndex != itemIndexOfSeperator) {
              return OpenContainer(
                closedBuilder: (context, action) {
                  return ProductCartCard(
                    image: purchasedItems[itemIndex]['image'],
                    title: purchasedItems[itemIndex]['title'],
                    id: purchasedItems[itemIndex]['id'],
                    itemCount: purchasedItems[itemIndex]['itemCount'],
                    price: (purchasedItems[itemIndex]['price']).toDouble(),
                    priceVisible: true,
                    itemDataInCart: ItemDataInCart(data: []),
                  );
                },
                openBuilder: (context, action) {
                  for (int i = 0; i < allProductData.length; i++) {
                    if (allProductData[i]['id'] ==
                        purchasedItems[itemIndex]['id']) {
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
              if (count == itemCounts.length - 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      height: 5.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.deepOrangeAccent,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 2.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '${DateFormat.yMEd().add_jm().format(DateTime.parse(purchaseData[count + 1]['dateOfPurchase'].toDate().toString()))}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15.0,
                          letterSpacing: 2.0,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
