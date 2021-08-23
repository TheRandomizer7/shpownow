# shpownow
 This is a simple shopping app created in flutter and made for handling data of small data sizes, not meant for handling huge amount of product/item data. You can test out the debug version of the app [here](https://appetize.io/app/dy77a6at6eu1d7qcdetbtqeb1r?device=nexus5&scale=75&orientation=portrait&osVersion=8.1)
 
 You can see a demo video of the app [here](https://drive.google.com/file/d/1C-bFgYdWOJBE0Jx5HENLtmFoU8YJt7ik/view?usp=sharing)
 
For the release apk files of the app, [click here](https://github.com/TheRandomizer7/shpownow/tree/master/release%20apks)

## Features overview
* User authentication using email id, password and using google.
* login page has 3 buttons, 'sign up' leads to the sign up page using email id. The login, authenticates the user. The google sign in button logs in the user, with the help of google.
* google sign in gives the user the same username as the username in google (you cannot add a different username).
* the sign in page, allows the user to enter the username, email and password.
* If during a google sign in, there already exists a user logged in with the same email id, the username given by the user, during the sign up proccess, overrides the google username. Also all the data in the database remains the same. But, the user can no longer sign in using email id and password. (because that data is not stored in the database)
* Toast messages for errors/ wrong password/ weak password etc, are shown through out the app.
* For normal user messages like adding to cart/adding review/deleting review/deleting item from cart use snackbars
* The whole app is designed such that, if there is are new products in the website API call, the app will automatically add the new products to the database and everything should work as intended, however, this is not tested. (The only test that was done was to delete the whole database and then reopening the application and everything worked fine)
* There are also animations throughout the application which add a good feel while using the application. (used a premade animations package, animations were not made from scratch, except one animation between the login and signup pages)
* Also when the application boots up, the application checks if the user is signed in or not, if the user is signed in, then, the loading screen is shown. Otherwise, the Login page is shown.
* home screen has an app bar at the top which has 3 buttons which lets the user switch between the cart page, the user page, and the products page (I will refer to this as the home screen).
* If the user presses 'back button' on a cart page / user page, it will be redirected to the home screen. If on the home screen, the user presses 'back button' then there will be a confirmation dialog and then the user can exit the application
* Other alert dialogs are also present in places where required
* home screen shows a list of all products.
* Products can be filtered on various factors, one, the category that the product belongs to. There is a specific button which allows the user to select different categories. two, the search query. There is a search bar in which the app searches all the products and shows results of products whose titles contains the search query.
* On every product card tap, the application shows a product page which contain all the data related to the product including reviews and ratings.
* On the product page, the user can add item to cart, add review, delete a review (only reviews posted by the logged in user, can be deleted)
* If the user clicks on add to cart more than once, than the item count of the product increase with every subsequent click
* Every product page has a category button which shows the category of the product. By clicking on this button, will reroute you to the home page, where the user will be showed all the products that belong to the category that was just clicked.
* All data like reviews, items in cart, number of items in cart, are dynamically updated as soon as any change is detected.
* Items added to cart will be displayed in the cart which the user can go to, by clicking on the cart icon on the app bar in the home page.
* In the cart page, user can change the number of items of a particular product, the user can also delete items from the cart.
* If the user is satisfied with his cart, 'proceed to checkout' is pressed, where the pricing information is shown along with the total cost.
* After clicking 'proceed to checkout', a new button is shown 'buy now'. After clicking this button the user is rerouted to the products page and all the items are cleared from the cart and are added to the user info page.
* The user info page, like the cart page, can be accessed using a button in the app bar of the home page.
* In the user info page, user data is shown like the username, number of purchases and purchase history, along with relevent data product data and date of purchase.
* The user can also sign out in this page, and then is re routed to the login page if the sign out was successful.
* There are also small things added to ensure the stability of the app, such as, if the API call was not successful or there was some error in fetching the user data, the user is automatically signed out of the application.
* There is a refresh indicator in the home page which syncs all changes made in the database, with the application. Currently, app automatically updates only those changes that are made locally.

## Known issues
1) Snackbars not showing sometimes (rare), no idea what is causing this.

## Tried things that were not added in the final app
1) Loading screens after every time product data is shown. Every time API calls were made and all data was consistent at all times. But due to the slowness of the app due to all the loading screens, I removed every single loading screen except the first one and the app handles all data locally until the refresh indicator is triggered
 
## Project structure
### Application pages
1) main.dart
    * Reroutes to either loading or login screen depending on whether the user is logged in or not.
2) cart.dart
    * Contains a list view of items that are present in cart.
    * Takes data from StoreProducts and database. [See API calls](#api-calls)
    * User can click the button 'proceed to check out', then it shows the total price, and after purchasing the items, the items are cleared from cart, and pushed to the purchase history and user is sent to the products_page.dart
    * uses the product cart card widget. [See custom widgets](#custom-widgets)
3) home.dart
    * Contains 3 pages/tabs:
        1) user_info.dart
        2) products_page.dart
        3) cart.dart
    * User can switch between these 3 tabs using buttons that are present on the app bar
4) loading.dart
    * Contains a spinkit widget. [See external packages](#external-packages-used)
    * Starts when the application just opens, gets all product data and then, pushes home.dart.
5) login.dart
    * Contains list view
    * User can login using an existing account with google/email id and password
    * If account does not exist (in database), it is automatically created using sign in with google
    * Uses AuthObject. [See flutter services](#flutter-services)
6) product.dart
    * Contains a list view of all the product data available.
    * Takes this data from StoreProducts and database. [See API calls](#api-calls)
    * User can add and delete reviews that are posted by the user that is currently logged in.
    * User can add items to cart.
    * 'Add review' displays a dialog box through which the user can post the review, this dialog box uses the rating bar package. [See external packages](#external-packages-used)
    * Uses the review card widget. [See custom widgets](#custom-widgets) 
7) products_page.dart
    * Contains a stack view containing a list view of all products (and filters), and a search bar.
    * Gets data from StoreProducts and database. [See API calls](#api-calls)
    * User can browse and filter items.
    * item filtering is based on categories, plus one category 'all products'
    * search bar also shows a preview of items that are going to be displayed after pressing the search button on the keyboard.
    * The list view of all products uses the product cart widget. [See custom widgets](#custom-widgets)
    * The search bar uses the floating search bar package. [See external packages](#external-packages-used)
    * The search bar also uses the search bar card to display items. [See custom widget](#custom-widgets)
8) sign_up.dart
    * Contains a list view
    * User can create a new account using email and password
    * Uses AuthObject. [See flutter services](#flutter-services)
9) user_info.dart
    * Contains a list view of all user data
    * Gets data from StoreProducts and database. [See API calls](#api-calls)
    * User can sign out here, taken to the login screen right after
    * User can also view number of purchases and all purchase related data here
    * uses the product cart card widget. [See custom widgets](#custom-widgets)

### Database structure
2 collections, 'Products' and 'Users'.
1) 'Products' collection has documents of every product. Every product's document name is it's product id which is taken from the API call to the website where product data is stored. Data stored in database is, rating of product, review count of product and a list of maps containing reviews of all the users. Every review is unique (seperated by uid of user, which is also used to determine if the review can be deleted by the current user or not).
2) 'Users' collection has documents of every user. Every user's document name is the user's uid, which is taken when the user is signed up or when signed in with google. Data stored is, items in cart, number of purchases, and purchase history which is a list of maps. Date of purchase is stored, which seperates different purchases in the UI.

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
