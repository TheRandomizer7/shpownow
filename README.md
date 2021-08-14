# shpownow
 This is a simple shopping app created in flutter and made for handling data of small data sizes, not meant for handling huge amount of product/item data. You can test out the debug version of the app [here](https://appetize.io/app/c9dhavkpzdg34yw17wb0b82pfg?device=nexus5&scale=75&orientation=portrait&osVersion=8.1)
 
 
For the release apk files of the app, [click here](https://github.com/TheRandomizer7/shpownow/tree/master/release)
 
## Project structure
### Custom classes/services
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
