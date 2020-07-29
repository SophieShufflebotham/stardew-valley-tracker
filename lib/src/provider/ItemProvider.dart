import 'package:flutter/material.dart';

import '../../model/model.dart';

class ItemProvider with ChangeNotifier {
  Item _item;

  ItemProvider(this._item);

  set item(Item item) {
    this._item = item;
    notifyListeners();
  }

  Item get item => _item;

  set complete(bool complete) {
    _item.complete = complete;
    _item.save();

    updateBundleCompletion(complete);

    notifyListeners();
  }

  void updateBundleCompletion(bool itemComplete) async {
    if (itemComplete) {
      _item.plBundle.numCompleted++;
    } else {
      _item.plBundle.numCompleted--;
    }

    await _item.plBundle.save();

    notifyListeners();
  }

  get complete => _item.complete;
}
