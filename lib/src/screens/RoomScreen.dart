import 'package:flutter/material.dart';
// import 'package:test_project/src/widgets/ImageHeaderScaffold.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';

class RoomScreen extends StatefulWidget {
  final int id;
  final Room room;

  RoomScreen({
    this.id,
    this.room,
  });

  @override
  State<StatefulWidget> createState() {
    return RoomScreenState(
      room: room,
    );
  }
}

class RoomScreenState extends State<RoomScreen> {
  Room _room;
  // Image _headerImage;
  Map<int, ImageProvider> _iconImages = Map<int, ImageProvider>();
  List<Bundle> _bundles = new List();
  String _title;
  // int _roomId;

  RoomScreenState({@required Room room}) {
    _title = room.name;
    // _headerImage = Image.asset(room.headerImagePath, fit: BoxFit.cover);
    // _roomId = room.id;
    getDatabaseContent(room);
  }

  @override
  Widget build(BuildContext context) {
    // var listSliver = SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (context, index) {
    //       if (index < _bundles.length) {
    //         return _buildListItem(context, index);
    //       }
    //       return null;
    //     },
    //   ),
    // );

    // return Scaffold(
    //   body: ImageHeader(
    //     title: _title,
    //     image: _headerImage,
    //     slivers: [listSliver],
    //   ),
    // );

    return Scaffold(
      appBar: new AppBar(title: Text(_title)),
      body: ListView.builder(
        itemCount: _bundles.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int i) {
    var bundle = _bundles[i];

    if (!_iconImages.containsKey(bundle.id)) {
      _iconImages.putIfAbsent(
        bundle.id,
        () => AssetImage(bundle.iconPath),
      );
    }

    return ListItem(
      name: bundle == null ? " " : bundle.name,
      iconImage: _iconImages[bundle.id],
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
    _room = await Room().getById(room.id);

    List<Bundle> bundles = await _room.getBundles().toList();

    if (bundles.length > 0) {
      setState(() {
        _bundles = bundles;
      });
    }
  }
}
