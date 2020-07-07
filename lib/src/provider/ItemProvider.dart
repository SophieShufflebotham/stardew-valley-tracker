import 'package:flutter/material.dart';

import '../../model/model.dart';

class ItemProvider with ChangeNotifier {
  Item _item;

  ItemProvider(this._item);

  set item(Item item) {
    this.item = item;
    notifyListeners();
  }

  Item get item => _item;

  set complete(bool complete) {
    _item.complete = complete;
    _item.save();
    notifyListeners();
  }

  get complete => _item.complete;
}
