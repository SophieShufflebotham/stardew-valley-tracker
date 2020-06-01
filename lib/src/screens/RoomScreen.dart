import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/src/screens/HomeScreen.dart';
import 'package:flutter/scheduler.dart';

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
    print("build");
    return Scaffold(
      appBar: new AppBar(
          title: Text(_room.name),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true))),
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
        );
        getDatabaseContent(_room);
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
