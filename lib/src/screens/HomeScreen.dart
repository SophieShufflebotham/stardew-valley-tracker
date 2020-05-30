import 'package:flutter/material.dart';
import 'package:test_project/src/screens/RoomScreen.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/tools/populateDb.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  final _rooms = [
    "Crafts Room",
    "Boiler Room",
  ];
  @override
  Widget build(BuildContext context) {
    PopulateDb().populateRooms();
    return Scaffold(
      appBar: AppBar(
        title: Text("Stardew Valley Checklist"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _rooms.length, itemBuilder: _buildListItem);
  }

  Widget _buildListItem(BuildContext context, int i) {
    var roomName = _rooms[i];
    var imageName = roomName.toLowerCase().replaceAll(' ', '_') + "_icon";

    return ListItem(
      name: roomName,
      iconImage: AssetImage("graphics/$imageName.png"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => RoomScreen(roomName: roomName),
          ),
        );
      },
    );
  }
}
