import 'package:flutter/material.dart';
import 'package:test_project/model/model.dart';

import 'BundleProvider.dart';

class RoomProvider with ChangeNotifier {
  Room _room;
  List<BundleProvider> _bundles = List<BundleProvider>();

  RoomProvider(this._room) {
    getDatabaseContent();
  }

  void getDatabaseContent() async {
    List<Bundle> bundles = await _room.getBundles().toList(preload: true);

    if (bundles.length > 0) {
      for (var bundle in bundles) {
        _bundles.add(BundleProvider(bundle));
      }
      notifyListeners();
    }
  }

  List<BundleProvider> get bundles => _bundles;

  Room get room => _room;
}
