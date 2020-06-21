import 'package:flutter/material.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';

import '../../model/model.dart';

class SearchProvider with ChangeNotifier {
  String _searchTerm = '';
  List<ItemProvider> _items = List<ItemProvider>();

  SearchProvider() {
    loadItems();
  }

  set searchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;

  List<ItemProvider> get items {
    return _items.where((item) {
      return item.item.name.toLowerCase().contains(_searchTerm.toLowerCase());
    }).toList();
  }

  loadItems() async {
    List<Item> items = await Item().select().toList(preload: true);

    if (items.length > 0) {
      for (var item in items) {
        _items.add(ItemProvider(item));
      }
    }
    notifyListeners();
  }
}
