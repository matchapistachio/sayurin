import 'package:flutter/foundation.dart';
import 'package:sayurin/models/vegetable.dart';

class ShoppinglistService extends ChangeNotifier {
  final List<Vegetable> _shoppingList = [];

  List<Vegetable> get shoppingList => List.unmodifiable(_shoppingList);

  bool isInShoppinglist(int vegetableId) {
    return _shoppingList.any((m) => m.id == vegetableId);
  }

  void toggleShoppinglist(Vegetable vegetable) {
    if (isInShoppinglist(vegetable.id)) {
      _shoppingList.removeWhere((m) => m.id == vegetable.id);
    } else {
      _shoppingList.add(vegetable);
    }
    notifyListeners();
  }

  void addToShoppinglist(Vegetable vegetable) {
    if (!isInShoppinglist(vegetable.id)) {
      _shoppingList.add(vegetable);
      notifyListeners();
    }
  }

  void removeFromShoppinglist(int vegetableId) {
    _shoppingList.removeWhere((m) => m.id == vegetableId);
    notifyListeners();
  }

  void seedInitialVegetables(List<Vegetable> vegetables) {
    if (_shoppingList.isEmpty && vegetables.isNotEmpty) {
      _shoppingList.add(vegetables.first);
      notifyListeners();
    }
  }
}