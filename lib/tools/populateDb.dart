import 'package:test_project/model/model.dart';

class PopulateDb {
  Future<bool> initialiseDatabase() async {
    bool roomSuccess = await populateRooms();
    bool bundleSuccess = await populateBundles();
    bool itemSuccess = await populateItems();

    if (!roomSuccess || !bundleSuccess || !itemSuccess) {
      return false;
    } else {
      return true;
    }
  }

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

  Future<bool> populateItems() async {
    var itemList = await Item.fromWebUrl(tableItems.defaultJsonUrl);
    final results = await Item().upsertAll(itemList);

    return results.success;
  }
}
