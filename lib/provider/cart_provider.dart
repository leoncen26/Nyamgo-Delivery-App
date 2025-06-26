import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier{
  List items =[];
  List get item => items;

  double get total {
    double total = 0;
    for (var element in items) {
      final price = double.tryParse(element['price'].toString()) ?? 0;
      final quantity = element['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

   void setItems(List newItems) {
    items = newItems;
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }
}