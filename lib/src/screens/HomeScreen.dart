import 'package:flutter/material.dart';
import 'package:test_project/src/screens/RoomScreen.dart';
import 'package:test_project/src/widgets/ListItem.dart';

import 'SearchScreen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Stardew Valley Checklist"),
      ),
      body: _buildList(),
      bottomNavigationBar: _createNavBar(),
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

  Widget _createNavBar() {
    return Container(
        height: 50.0,
        child: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {},
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return SearchScreen();
                              },
                            ),
                          )
                        }),
              ]),
        ));
  }
}
