import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/src/screens/HomeScreen.dart';

class RoomScreen extends StatefulWidget {
  final Room room;

  RoomScreen({@required this.room});

  @override
  State<StatefulWidget> createState() {
    return RoomScreenState(room: room);
  }
}

class RoomScreenState extends State<RoomScreen> {
  Room _room;
  List<Bundle> _bundles = new List();

  RoomScreenState({@required Room room}) {
    _room = room;
    getDatabaseContent(room);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(_room.name),
      ),
      body: ListView.builder(
        itemCount: _bundles.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int i) {
    var bundle = _bundles[i];
    var itemList = bundle.plItems;
    var completedItemList = itemList.where((item) => item.complete).toList();

    return ListItem(
      name: bundle.name,
      subtitle: "${completedItemList.length}/${itemList.length} Completed",
      iconImage: AssetImage(bundle.iconPath),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BundleScreen(bundle: bundle),
          ),
        ).then((value) => setState(() async {
              List<Item> newItems = await bundle.getItems().toList();
              List<Item> completed = newItems.where((item) => item.complete);

              if (completedItemList.length != completed.length) {
                completedItemList.clear();
                completedItemList.addAll(completed);
              }
            }));
      },
    );
  }

  void getDatabaseContent(Room room) async {
    List<Bundle> bundles = await _room.getBundles().toList(preload: true);

    if (bundles.length > 0) {
      setState(() {
        _bundles = bundles;
      });
    }
  }
}
