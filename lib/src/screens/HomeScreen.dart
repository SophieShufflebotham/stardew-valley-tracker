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
  List<Room> _rooms = new List<Room>();

  HomeScreenState() {
    getDatabaseContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stardew Valley Checklist"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    Widget retVal =
        ListView.builder(itemCount: _rooms.length, itemBuilder: _buildListItem);

    return retVal;
  }

  Widget _buildListItem(BuildContext context, int i) {
    var roomName = _rooms[i].name;
    var roomId = _rooms[i].id;
    var imageName = roomName.toLowerCase().replaceAll(' ', '_') + "_icon";

    return ListItem(
      name: roomName,
      iconImage: AssetImage("graphics/placeholder.png"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                RoomScreen(roomName: roomName, parentId: roomId),
          ),
        );
      },
    );
  }

  void getDatabaseContent() async {
    bool success = await PopulateDb().populateRooms();
    if (success) {
      List<Room> roomsList = await Room().select().toList();

      setState(() {
        _rooms = roomsList;
      });
    }
  }
}
