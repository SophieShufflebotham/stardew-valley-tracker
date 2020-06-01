import 'package:flutter/material.dart';
import '../widgets/SquareAvatar.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/src/screens/RoomScreen.dart';

class BundleScreen extends StatefulWidget {
  final Bundle bundle;

  BundleScreen({@required this.bundle});

  @override
  State<StatefulWidget> createState() {
    return BundleScreenState(bundle: bundle);
  }
}

class BundleScreenState extends State<BundleScreen> {
  Bundle bundle;

  List<Item> _items = new List<Item>();

  BundleScreenState({@required this.bundle}) {
    getDatabaseContent();
  }

  Widget _buildListItem(BuildContext context, int i) {
    Item item = _items[i];

    return ListTile(
      title: Text(item.name),
      leading: SquareAvatar(backgroundImage: AssetImage(item.iconPath)),
      trailing: Switch(
        activeColor: Colors.lightGreen,
        value: item.complete,
        onChanged: (value) {
          toggleItemComplete(item);
        },
      ),
      onTap: () {
        toggleItemComplete(item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(bundle.name),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true)),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  void getDatabaseContent() async {
    List<Item> items = await bundle.getItems().toList(preload: true);

    if (items.length > 0) {
      setState(() {
        _items = items;
      });
    }
  }

  void toggleItemComplete(Item item) async {
    setState(() {
      item.complete = !item.complete;
      item.save();
    });
  }
}
