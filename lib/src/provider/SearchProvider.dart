import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';

import '../../model/model.dart';

class SearchProvider with ChangeNotifier {
  String _searchTerm = '';
  List<ItemProvider> _items = List<ItemProvider>();
  Map _completionStatuses = new Map();

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
    _completionStatuses = new Map();
    List<Item> items = await Item().select().toList(preload: true);
    createCompletionStatusMap(items);

    if (items.length > 0) {
      for (var item in items) {
        var provider = ItemProvider(item);
        provider.addListener(notifyListeners);
        _items.add(provider);
      }
    }
    notifyListeners();
  }

  updateCompletionStatus(int key, var value) {
    _completionStatuses[key] = value;
    notifyListeners();
  }

  createCompletionStatusMap(List<Item> items) {
    for (var i = 0; i < items.length; i++) {
      var bundleCompletion =
          items[i].plBundle.numCompleted >= items[i].plBundle.numItemsRequired;

      if (bundleCompletion && !items[i].complete) {
        _completionStatuses[items[i].id] = null;
      } else {
        _completionStatuses[items[i].id] = items[i].complete;
      }
    }
  }

  Map get completionStatuses => _completionStatuses;

  @override
  void dispose() {
    // Remove listeners from ItemProvider's
    for (var item in items) {
      item.removeListener(notifyListeners);
      item.dispose();
    }

    super.dispose();
  }
}
