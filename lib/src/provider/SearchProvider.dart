import 'package:flutter/material.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';

import '../../model/model.dart';

class SearchProvider with ChangeNotifier {
  String _searchTerm = '';
  List<ItemProvider> _items = List<ItemProvider>();
  Map _completionStatuses = new Map();
  bool _isLoading = true;

  SearchProvider() {
    loadItems();
  }

  set searchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;
  bool get isLoading => _isLoading;

  List<ItemProvider> get items {
    return _items.where((item) {
      var searchBundleName = item.item.plBundle.name
          .toLowerCase()
          .contains(_searchTerm.toLowerCase());
      bool searchItemName =
          item.item.name.toLowerCase().contains(_searchTerm.toLowerCase());
      return searchBundleName || searchItemName;
    }).toList();
  }

  loadItems() async {
    _completionStatuses = new Map();
    List<Item> items = await Item().select().toList(preload: true);

    if (items.length > 0) {
      for (var item in items) {
        _addToCompletionStatusMap(item);

        var provider = ItemProvider(item);
        provider.addListener(notifyListeners);
        _items.add(provider);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  updateCompletionStatus(int key, var value) {
    _completionStatuses[key] = value;
    notifyListeners();
  }

  _addToCompletionStatusMap(Item item) {
    var bundle = item.plBundle;
    var bundleCompletion = bundle.numCompleted >= bundle.numItemsRequired;

    if (bundleCompletion && !item.complete) {
      _completionStatuses[item.id] = null;
    } else {
      _completionStatuses[item.id] = item.complete;
    }
  }

  Map get completionStatuses => _completionStatuses;

  @override
  void dispose() {
    // Remove listeners from ItemProvider's
    for (var item in items) {
      item.removeListener(notifyListeners);
    }

    super.dispose();
  }
}
