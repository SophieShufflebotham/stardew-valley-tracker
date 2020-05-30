import 'package:test_project/model/model.dart';

class PopulateDb {
  final roomsList = [
    "Crafts Room",
    "Boiler Room",
    "Pantry",
    "Fish Tank",
    "Bulletin Board",
    "Vault"
  ];

  void populateRooms() async {
    for (var i = 0; i < roomsList.length; i++) {
      var roomName = roomsList[i];
      var imageName = roomName.toLowerCase().replaceAll(' ', '_');
      await Room.withFields(roomName, "graphics/$imageName" + "_icon.png",
              "graphics/$imageName.png")
          .save();
    }
    sampleSelectStatement();
  }

  void sampleSelectStatement() async {
    List<Room> listOfValues = await Room().select().toList();
    for (var i = 0; i < listOfValues.length; i++) {
      print("Room: " + listOfValues[i].name);
    }
  }

  void populateBundles() {}
  void populateItems() {}
}
