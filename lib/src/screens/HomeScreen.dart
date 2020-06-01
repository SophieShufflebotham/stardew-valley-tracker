import 'package:flutter/material.dart';
import 'package:test_project/src/screens/RoomScreen.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/tools/populateDb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Room> _rooms = new List<Room>();

  HomeScreenState() {
    initialiseDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Center')),
      body: ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int i) {
    var room = _rooms[i];
    var bundleList = room.plBundles;

    var completeBundleList = bundleList.where((bundle) =>
        bundle.plItems.length ==
        bundle.plItems.where((item) => item.complete).length);

    String subtitle =
        "${completeBundleList.length}/${bundleList.length} Completed";

    return ListItem(
      name: room.name,
      subtitle: subtitle,
      iconImage: AssetImage(room.iconPath),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => RoomScreen(room: _rooms[i]),
          ),
        );
        initialiseDatabase();
      },
    );
  }

  void getDatabaseContent() async {
    List<Room> roomsList = await Room().select().toList(preload: true);

    setState(() {
      _rooms = roomsList;
    });
  }

  void initialiseDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if this is the first run of the application.
    if (!(prefs.getBool('dbReady') == true)) {
      bool success = await PopulateDb().initialiseDatabase();
      prefs.setBool('dbReady', success);
    }

    getDatabaseContent();
  }
}
