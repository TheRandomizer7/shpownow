import 'package:flutter/material.dart';
import 'package:shpownow/services/custom%20classes/item_data_in_cart.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class ProductCartCard extends StatefulWidget {
  final String title;
  final String image;
  final int itemCount;
  final int id;
  final double price;
  final bool priceVisible;
  final FirestoreObject firestoreObject = FirestoreObject();
  final ItemDataInCart itemDataInCart;

  ProductCartCard({
    required this.title,
    required this.image,
    required this.itemCount,
    required this.id,
    required this.price,
    required this.priceVisible,
    required this.itemDataInCart,
  });

  @override
  _ProductCartCardState createState() => _ProductCartCardState();
}

class _ProductCartCardState extends State<ProductCartCard> {
  int itemCount = -1;
  @override
  Widget build(BuildContext context) {
    if (itemCount == -1) {
      itemCount = widget.itemCount;
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.325,
            child: Image.network(
              widget.image,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.375,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !widget.priceVisible,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirm action',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    content: Text(
                                      'This will remove this item from your cart permanently, are you sure you want to proceed?',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          FirestoreObject firestoreObject =
                                              FirestoreObject();
                                          bool success = await firestoreObject
                                              .deleteItemFromCart(widget.id);
                                          if (success) {
                                            Navigator.pop(context);
                                            for (int i = 0;
                                                i <
                                                    widget.itemDataInCart.data
                                                        .length;
                                                i++) {
                                              if (widget.id ==
                                                  widget.itemDataInCart.data[i]
                                                      ['id']) {
                                                widget.itemDataInCart.data
                                                    .removeAt(i);
                                              }
                                            }
                                            widget.itemDataInCart.length.value =
                                                widget
                                                    .itemDataInCart.data.length;
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel'),
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
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Visibility(
                          visible: !widget.priceVisible,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              if (itemCount > 1) {
                                setState(() {
                                  itemCount -= 1;
                                });
                                print(itemCount);
                                bool success = await widget.firestoreObject
                                    .updateItemCount(widget.id, itemCount);
                                if (!success) {
                                  setState(() {
                                    itemCount += 1;
                                  });
                                } else {
                                  for (int i = 0;
                                      i < widget.itemDataInCart.data.length;
                                      i++) {
                                    if (widget.id ==
                                        widget.itemDataInCart.data[i]['id']) {
                                      widget.itemDataInCart.data[i]
                                          ['itemCount'] = itemCount;
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '× $itemCount',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Visibility(
                          visible: !widget.priceVisible,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              setState(() {
                                itemCount += 1;
                              });
                              bool success = await widget.firestoreObject
                                  .updateItemCount(widget.id, itemCount);
                              if (!success) {
                                itemCount -= 1;
                              } else {
                                for (int i = 0;
                                    i < widget.itemDataInCart.data.length;
                                    i++) {
                                  if (widget.id ==
                                      widget.itemDataInCart.data[i]['id']) {
                                    widget.itemDataInCart.data[i]['itemCount'] =
                                        itemCount;
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '₹ ${widget.price}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
