import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shpownow/services/store_api.dart';

class FirestoreObject {
  Future<bool> addUser(String username) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'username': username,
        'no_of_purchases': 0,
        'itemsInCart': [],
        'purchaseData': [],
      });
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> addGoogleUser(String username) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}');
      DocumentSnapshot snapshot = await documentReference.get();
      if (snapshot.data() == null) {
        addUser(username);
      }
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> addProduct(String title, int id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Products').doc('$id');
      DocumentSnapshot snapshot = await documentReference.get();
      if (!snapshot.exists) {
        await documentReference.set(
            {'title': title, 'review_count': 0, 'reviews': [], 'rating': 0.0});
      }
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<double> getRating(int id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('$id')
        .get();
    dynamic rating = (snapshot.data() as Map)['rating'];
    return double.parse('$rating');
  }

  Future<int> getReviewCount(int id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('$id')
        .get();
    int reviewCount = (snapshot.data() as Map)['review_count'];
    return reviewCount;
  }

  Future<Map> getProductData(Map data, int id) async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('$id')
        .get();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    Map productDataFromDatabase = (productSnapshot.data() as Map);
    Map userDataFromDatabase = (userSnapshot.data() as Map);
    Map finalData = {
      ...data,
      ...{
        'rating': productDataFromDatabase['rating'],
        'review_count': productDataFromDatabase['review_count'],
        'reviews': productDataFromDatabase['reviews'],
        'username': userDataFromDatabase['username'],
        'uid': uid,
      },
    };
    return finalData;
  }

  Future<bool> addProductReview(String reviewText, double rating,
      String username, int id, String uid) async {
    try {
      reviewText = reviewText.trim();
      Map review = {
        'review_text': reviewText,
        'rating': rating,
        'username': username,
        'uid': uid,
      };
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Products').doc('$id');
      DocumentSnapshot snapshot = await documentReference.get();
      int currentReviewCount = (snapshot.data() as Map)['review_count'];
      double currentRating = (snapshot.data() as Map)['rating'].toDouble();
      List reviews = (snapshot.data() as Map)['reviews'];
      reviews.add(review);
      int newReviewCount = currentReviewCount + 1;
      double newRating = (((((currentRating * currentReviewCount) + rating) /
                      (newReviewCount / 2))
                  .round()
                  .toDouble()) /
              2)
          .toDouble();

      await documentReference.set({
        'rating': newRating,
        'review_count': newReviewCount,
        'reviews': reviews,
      });

      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> addProductToCart(String uid, int id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Users').doc('$uid');
      DocumentSnapshot snapshot = await documentReference.get();
      Map userData = snapshot.data() as Map;
      List itemsInCart = userData['itemsInCart'];
      bool itemAlreadyInCart = false;
      for (int i = 0; i < itemsInCart.length; i++) {
        if (itemsInCart[i]['id'] == id) {
          itemAlreadyInCart = true;
          itemsInCart[i]['itemCount'] += 1;
          break;
        }
      }
      if (!itemAlreadyInCart) {
        itemsInCart.add({
          'id': id,
          'itemCount': 1,
        });
      }
      await documentReference.update({
        'itemsInCart': itemsInCart,
      });
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<List> getUserCartData(StoreProducts storeProducts) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map userData = snapshot.data() as Map;
      List itemDataInCart = userData['itemsInCart'];
      List allProductData = storeProducts.allProductData;
      for (int i = 0; i < itemDataInCart.length; i++) {
        Map itemData = {};
        for (int j = 0; j < allProductData.length; j++) {
          if (allProductData[j]['id'] == itemDataInCart[i]['id']) {
            itemData = allProductData[j];
            break;
          }
        }
        itemDataInCart[i] = {
          ...itemDataInCart[i],
          ...itemData,
        };
      }
      return itemDataInCart;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return [];
    }
  }

  Future<bool> updateItemCount(int id, int itemCount) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot snapshot = await documentReference.get();
      Map userData = snapshot.data() as Map;
      List itemsInCart = userData['itemsInCart'];
      for (int i = 0; i < itemsInCart.length; i++) {
        if (itemsInCart[i]['id'] == id) {
          itemsInCart[i]['itemCount'] = itemCount;
          break;
        }
      }
      await documentReference.update({
        'itemsInCart': itemsInCart,
      });

      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> purchaseProductsInCart() async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot snapshot = await documentReference.get();
      Map userData = snapshot.data() as Map;
      List itemsInCart = userData['itemsInCart'];
      List purchaseData = userData['purchaseData'];
      Map currentPurchaseData = {
        'purchasedItems': itemsInCart,
        'dateOfPurchase': DateTime.now(),
      };
      purchaseData.insert(0, currentPurchaseData);
      await documentReference.update({
        'no_of_purchases': userData['no_of_purchases'] + 1,
        'itemsInCart': [],
        'purchaseData': purchaseData,
      });
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<Map> getUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      return (snapshot.data() as Map);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return {};
    }
  }

  Future<List> getUserPurchasedData(StoreProducts storeProducts) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map userData = snapshot.data() as Map;
      List purchaseData = userData['purchaseData'];
      List allProductData = storeProducts.allProductData;
      for (int i = 0; i < purchaseData.length; i++) {
        List purchasedItems = purchaseData[i]['purchasedItems'];
        for (int j = 0; j < purchasedItems.length; j++) {
          Map itemData = {};
          for (int k = 0; k < allProductData.length; k++) {
            if (allProductData[k]['id'] == purchasedItems[j]['id']) {
              itemData = allProductData[k];
              break;
            }
          }
          purchasedItems[j] = {
            ...purchasedItems[j],
            ...itemData,
          };
        }
      }
      return purchaseData;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return [];
    }
  }

  Future<bool> deleteItemFromCart(int id) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot snapshot = await documentReference.get();
      List itemsInCart = (snapshot.data() as Map)['itemsInCart'];
      for (int i = 0; i < itemsInCart.length; i++) {
        if (itemsInCart[i]['id'] == id) {
          itemsInCart.removeAt(i);
          break;
        }
      }
      await documentReference.update({'itemsInCart': itemsInCart});
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> deleteReview(int index, int id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Products').doc('$id');
      DocumentSnapshot snapshot = await documentReference.get();
      List reviews = (snapshot.data() as Map)['reviews'];
      int reviewCount;
      double rating = 0;

      reviews.removeAt(index);
      reviewCount = reviews.length;
      for (int i = 0; i < reviews.length; i++) {
        rating += reviews[i]['rating'] / reviewCount;
      }

      rating = ((2 * rating).round().toDouble()) / 2.0;

      await documentReference.update(
          {'reviews': reviews, 'review_count': reviewCount, 'rating': rating});

      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }
}
