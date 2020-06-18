import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/src/provider/HomeProvider.dart';
import 'package:test_project/src/provider/RoomProvider.dart';
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

  HomeScreenState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Community Center')),
        body: Consumer<HomeProvider>(builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.rooms.length,
            itemBuilder: (context, i) =>
                _buildListItem(context, i, provider.rooms[i]),
          );
        }),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, int i, RoomProvider roomProvider) {
    return ChangeNotifierProvider.value(
      value: roomProvider,
      child: Consumer<RoomProvider>(
        builder: (context, provider, ___) {
          var completeBundleList = provider.room.plBundles.where((bundle) =>
              bundle.plItems.length ==
              bundle.plItems.where((item) => item.complete).length);

          String subtitle =
              "${completeBundleList.length}/${provider.room.plBundles.length} Completed";

          return ListItem(
            name: provider.room.name,
            subtitle: subtitle,
            iconImage: AssetImage(provider.room.iconPath),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => RoomScreen(
                    roomProvider: provider,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
