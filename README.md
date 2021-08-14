# shpownow
 This is a simple shopping app created in flutter and made for handling data of small data sizes, not meant for handling huge amount of product/item data. You can test out the debug version of the app [here](https://appetize.io/app/c9dhavkpzdg34yw17wb0b82pfg?device=nexus5&scale=75&orientation=portrait&osVersion=8.1)
 
 
For the release apk files of the app, [click here](https://github.com/TheRandomizer7/shpownow/tree/master/release)

## Features overview
 
## Project structure
### External packages used
1) firebase_core - connecting to firebase
2) firebase_auth - to use firebase authentication
3) google_sign_in - to use google sign in
5) cloud_firestore - to use firestore database
6) http - to make API calls
7) flutter_spinkit - to use a loading screen widget
8) flutter_rating_bar - to have a rating bar adjustable by user
9) fluttertoast - to use toast messages
10) animations - to use premade animations in flutter
11) intl - to format date and time in the required format
12) material_floating_search_bar - to have a search bar widget
### Custom classes/services
#### Classes created to act like pointers
(To access parent data inside of a child widget)  
1) ItemDataInCart - has 2 variables, one is a data variable which is an array of maps. Second variable is an integer which holds the length of the data array.
2) ReviewData - has 1 variable which holds data of type array of maps.
#### Flutter services
1) FirestoreObject - handles all the firestore related functions like storing and reading user data such as items in cart and items purchased in all of time. product data such as reviews and ratings.
2) AuthObject - handles all authentication functions like signing in, signing out and using google sign in.
#### API calls
1) StoreProducts - handles API calling to website and keeps a store of all the data from the website. Also handles that data, merges data from firestore database using FirestoreObject, categorizing and variety of functions.
### Custom widgets
1) product_card.dart
    * parent widget - products_page.dart
    * takes in arguments - title, web image link, total number of reviews, total rating, id, and price of product.
    * on click - opens product.dart
2) product_cart_card.dart
    * parent widget - cart.dart and user_info.dart
    * takes in arguments - title, web image link, number of items, id, price, of the product, is the price visible?, FirestoreObject and ItemDataInCart object.
    * on click - opens product.dart
3) review_card.dart
    * parent widget - product.dart
    * takes in arguments - username, individual product rating, review text, whether delete should be possible or not, index of review, id of product, ReviewData object
    * on click - opens product.dart
4) search_bar_card.dart
    * parent widget - home.dart
    * takes in arguments - title, web image link, number of reviews, total rating, and id of product.
    * on click - opens product.dart
5) star_rating_bar.dart
    * parent widget - product_card.dart, review_card.dart, product.dart, producte_cart_card.dart, search_bar_card.dart
    * takes in arguments - rating, size of icons
    * on click - nothing happens
### Application pages
