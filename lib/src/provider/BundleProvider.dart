import 'package:flutter/material.dart';

import '../../model/model.dart';
import 'ItemProvider.dart';

class BundleProvider with ChangeNotifier {
  Bundle _bundle;
  List<ItemProvider> _items = List<ItemProvider>();

  BundleProvider(this._bundle) {
    if (_bundle.plItems.length > 0) {
      for (var item in _bundle.plItems) {
        var provider = ItemProvider(item);
        provider.addListener(notifyListeners);
        _items.add(provider);
      }
      notifyListeners();
    }
  }
  List<ItemProvider> get items => _items ?? List<Item>();

  Bundle get bundle => _bundle;

  int get numCompleted => _bundle.numCompleted;
  set numCompleted(value) {
    _bundle.numCompleted = value;
    _bundle.save();
    notifyListeners();
  }

  @override
  dispose() {
    for (var item in _items) {
      item.removeListener(notifyListeners);
      item.dispose();
    }

    super.dispose();
  }
}
