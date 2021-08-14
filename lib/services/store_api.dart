// Properties of every product recieved as per the website api: 
// id - int
// title - String
// description - String
// category - String
// image - String linking to the image of the product
// price - double

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class StoreProducts{

  List products = [];
  List tempProductData = [];
  List allProductData = [];
  List allCategories = [];
  List queryProducts = [];
  ValueNotifier<String> productsToLoad = ValueNotifier<String>("allProducts");

  Future<void> initializeStoreProducts() async{
    Response response = await get(Uri.parse('https://fakestoreapi.com/products'));
    products = jsonDecode(response.body);

    await checkIfProductsInitialized();

    for(int i = 0; i < products.length; i++){
      FirestoreObject firestoreObject = FirestoreObject();
      Map data = products[i];
      
      data = await firestoreObject.getProductData(data, products[i]['id']);
      allProductData.add(data);

      setTempProducts(productsToLoad.value);

      bool newValue = true;
      for(int j = 0; j < allCategories.length; j++){
        if(allCategories[j] == products[i]['category']){
          newValue = false;
          break;
        }
      }
      if(newValue){
        allCategories.add('${products[i]['category']}');
      }
    }

    queryProducts = allProductData;
  }

  void setTempProducts(String category) {
    tempProductData = [];
    for(int i = 0; i < allProductData.length; i++){
      if(allProductData[i]['category'] == category){
        tempProductData.add(allProductData[i]);
      }
    }

    if(category == 'allProducts'){
      tempProductData = allProductData;
    }

    if(tempProductData.length == 0){
      for(int i = 0; i < allProductData.length; i++){
        if((allProductData[i]['title'].toLowerCase()).contains(category.toLowerCase())){
          tempProductData.add(allProductData[i]);
        }
      }
    }
  }

  Future<bool> checkIfProductsInitialized() async{
    try {
      FirestoreObject firestoreObject = FirestoreObject();
      for(int i = 0; i < products.length; i++){
        bool success = await firestoreObject.addProduct(products[i]['title'], products[i]['id']);
        if(!success){
          print(products[i]['title']);
          return false;
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map> getProductData(int id) async{
    try {
      Response response = await get(Uri.parse('https://fakestoreapi.com/products/$id'));
      Map productData = jsonDecode(response.body) as Map;
      return productData;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  void setQueryProducts(String query){
    queryProducts = [];
    for(int i = 0; i < allProductData.length; i++){
      if((allProductData[i]['title'].toLowerCase()).contains(query.toLowerCase())){
        queryProducts.add(allProductData[i]);
      }
    }
  }
}