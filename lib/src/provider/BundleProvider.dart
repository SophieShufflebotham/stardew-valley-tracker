import 'package:flutter/material.dart';

import '../../model/model.dart';
import 'ItemProvider.dart';

class BundleProvider with ChangeNotifier {
  Bundle _bundle;
  List<ItemProvider> _items = List<ItemProvider>();

  BundleProvider(this._bundle) {
    // get items from database
    getDatabaseContent();
  }

  void getDatabaseContent() async {
    List<Item> items = await _bundle.getItems().toList(preload: true);

    if (items.length > 0) {
      for (var item in items) {
        _items.add(ItemProvider(item));
      }
      notifyListeners();
    }
  }

  List<ItemProvider> get items => _items ?? List<Item>();

  Bundle get bundle => _bundle;
}
