import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';

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
      appBar: new AppBar(title: Text(_room.name)),
      body: ListView.builder(
        itemCount: _bundles.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int i) {
    var bundle = _bundles[i];

    return ListItem(
      name: bundle.name,
      iconImage: AssetImage(bundle.iconPath),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => BundleScreen(bundle: bundle),
          ),
        );
      },
    );
  }

  void getDatabaseContent(Room room) async {
    List<Bundle> bundles = await _room.getBundles().toList();

    if (bundles.length > 0) {
      setState(() {
        _bundles = bundles;
      });
    }
  }
}
