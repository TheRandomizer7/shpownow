import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shpownow/custom_widgets/product_card.dart';
import 'package:shpownow/custom_widgets/search_bar_card.dart';
import 'package:shpownow/pages/product.dart';
import 'package:shpownow/services/store_api.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();

  final StoreProducts storeProducts;

  ProductsPage({required this.storeProducts});
}

class _ProductsPageState extends State<ProductsPage> {
  StoreProducts updatedStoreProducts = StoreProducts();
  FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    StoreProducts storeProducts = widget.storeProducts;
    List allProductData = storeProducts.allProductData;

    Dialog filtersDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose category of products to view:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.grey[800],
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              color: storeProducts.productsToLoad.value == 'allProducts'
                  ? Colors.greenAccent[400]
                  : Colors.red,
              onPressed: () {
                storeProducts.productsToLoad.value = 'allProducts';
                Navigator.pop(context);
              },
              child: Text(
                'all products',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              color: Colors.grey[400],
              width: MediaQuery.of(context).size.width,
              height: 3.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemCount: storeProducts.allCategories.length,
              itemBuilder: (context, index) {
                return MaterialButton(
                  color: storeProducts.productsToLoad.value ==
                          storeProducts.allCategories[index]
                      ? Colors.greenAccent[400]
                      : Colors.red,
                  onPressed: () {
                    storeProducts.productsToLoad.value =
                        storeProducts.allCategories[index];
                    Navigator.pop(context);
                  },
                  child: Text(
                    storeProducts.allCategories[index],
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.0),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );

    return Stack(
      children: [
        ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: storeProducts.tempProductData.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.fromLTRB(15.0, 75.0, 15.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'showing: ${storeProducts.productsToLoad.value == 'allProducts' ? 'all products' : storeProducts.productsToLoad.value}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 17.0,
                          letterSpacing: 2.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        showModal(
                            configuration: FadeScaleTransitionConfiguration(
                              transitionDuration: Duration(milliseconds: 300),
                            ),
                            context: context,
                            builder: (context) => filtersDialog);
                      },
                      color: Colors.blue[400],
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              int tempIndex = index - 1;
              return OpenContainer(
                closedBuilder: (context, action) {
                  return ProductCard(
                    title: storeProducts.tempProductData[tempIndex]['title'],
                    image: storeProducts.tempProductData[tempIndex]['image'],
                    id: storeProducts.tempProductData[tempIndex]['id'],
                    reviewCount: storeProducts.tempProductData[tempIndex]
                        ['review_count'],
                    rating: storeProducts.tempProductData[tempIndex]['rating'],
                    price: storeProducts.tempProductData[tempIndex]['price']
                        .toDouble(),
                  );
                },
                openBuilder: (context, action) {
                  int productIndex = 0;
                  for (int i = 0; i < allProductData.length; i++) {
                    if (allProductData[i]['id'] ==
                        storeProducts.tempProductData[tempIndex]['id']) {
                      productIndex = i;
                      break;
                    }
                  }
                  return Product(
                    data: allProductData[productIndex],
                    storeProducts: storeProducts,
                  );
                },
              );
            }
          },
        ),
        FloatingSearchBar(
          margins: EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
          controller: controller,
          hint: 'Search all products',
          hintStyle: TextStyle(
              fontFamily: 'Roboto',
              letterSpacing: 2.0,
              color: Colors.grey[400],
              fontWeight: FontWeight.w800,
              fontSize: 15.0),
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 400),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          openAxisAlignment: 0.0,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            setState(() {
              storeProducts.setQueryProducts(query);
            });
          },
          onSubmitted: (query) {
            if (query == '') {
              query = 'allProducts';
            }
            storeProducts.productsToLoad.value = query;
            controller.close();
          },
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
          ],
          leadingActions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              showIfClosed: true,
              child: Icon(
                Icons.search,
                color: Colors.grey[700],
                size: 20.0,
              ),
            ),
          ],
          builder: (context, transition) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storeProducts.queryProducts.map((product) {
                      return OpenContainer(
                        closedBuilder: (context, action) {
                          return SearchBarCard(
                            title: product['title'],
                            image: product['image'],
                            id: product['id'],
                            reviewCount: product['review_count'],
                            rating: product['rating'],
                            price: product['price'].toDouble(),
                          );
                        },
                        openBuilder: (context, action) {
                          int productIndex = 0;
                          for (int i = 0; i < allProductData.length; i++) {
                            if (allProductData[i]['id'] == product['id']) {
                              productIndex = i;
                              break;
                            }
                          }
                          return Product(
                            data: allProductData[productIndex],
                            storeProducts: storeProducts,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
