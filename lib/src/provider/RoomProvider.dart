import 'package:flutter/material.dart';
import 'package:uk.co.tcork.stardew_companion/model/model.dart';

import 'BundleProvider.dart';

class RoomProvider with ChangeNotifier {
  Room _room;
  List<BundleProvider> _bundles = List<BundleProvider>();

  RoomProvider(this._room) {
    getDatabaseContent();
  }

  void getDatabaseContent() async {
    if (_room.plBundles.length > 0) {
      for (var bundle in _room.plBundles) {
        var provider = BundleProvider(bundle);
        provider.addListener(notifyListeners);
        _bundles.add(provider);
      }
      notifyListeners();
    }
  }

  List<BundleProvider> get bundles => _bundles;

  Room get room => _room;

  @override
  dispose() {
    for (var provider in _bundles) {
      provider.removeListener(notifyListeners);
    }

    super.dispose();
  }
}
