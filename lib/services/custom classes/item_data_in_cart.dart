import 'package:flutter/cupertino.dart';

class ItemDataInCart {
  dynamic data;
  ValueNotifier<int> length = ValueNotifier<int>(0);
  ItemDataInCart({required this.data});
}