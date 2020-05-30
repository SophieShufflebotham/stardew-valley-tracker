import 'package:test_project/model/model.dart';

class PopulateDb {
  Future<bool> populateRooms() async {
    var roomList = await Room.fromWebUrl(tableRooms.defaultJsonUrl);
    final results = await Room().upsertAll(roomList);

    return results.success;
  }

  Future<bool> populateBundles() async {
    var bundleList = await Bundle.fromWebUrl(tableBundles.defaultJsonUrl);
    final results = await Bundle().upsertAll(bundleList);

    return results.success;
  }
}
