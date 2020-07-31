import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uk.co.tcork.stardew_companion/model/model.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/RoomProvider.dart';
import 'package:uk.co.tcork.stardew_companion/tools/populateDb.dart';

class HomeProvider with ChangeNotifier {
  List<RoomProvider> _rooms = List<RoomProvider>();

  HomeProvider() {
    getDatabaseContent();
  }

  void getDatabaseContent() async {
    await initDatabase();

    List<Room> rooms = await Room().select().toList(preload: true);

    if (rooms.length > 0) {
      _rooms.clear();
      for (var room in rooms) {
        var provider = RoomProvider(room);
        provider.addListener(notifyListeners);
        _rooms.add(provider);
      }
      notifyListeners();
    }
  }

  List<RoomProvider> get rooms => _rooms;

  @override
  dispose() {
    for (var provider in _rooms) {
      provider.removeListener(notifyListeners);
    }

    super.dispose();
  }

  initDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if this is the first run of the application.
    if (!(prefs.getBool('dbReady') == true)) {
      bool success = await PopulateDb().initialiseDatabase();
      prefs.setBool('dbReady', success);
    }
  }
}
