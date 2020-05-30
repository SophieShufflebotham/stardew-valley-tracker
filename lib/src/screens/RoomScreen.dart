import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/FilteredHeaderImage.dart';
import 'package:test_project/src/widgets/ImageHeaderScaffold.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';

class RoomScreen extends StatefulWidget {
  final int id;

  RoomScreen({
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return RoomScreenState(
      id: id,
    );
  }
}

class RoomScreenState extends State<RoomScreen> {
  Room _room;
  Image _headerImage;
  Map<int, ImageProvider> _iconImages = Map<int, ImageProvider>();
  List<Bundle> _bundles = new List();

  final int id;

  RoomScreenState({@required this.id}) {
    getDatabaseContent();
  }

  @override
  Widget build(BuildContext context) {
    var listSliver = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < _bundles.length) {
            return _buildListItem(context, index);
          }
          return null;
        },
      ),
    );

    return Scaffold(
      body: ImageHeader(
        title: _room.name,
        image: _headerImage,
        slivers: [listSliver],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int i) {
    final bundle = _bundles[i];

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
            builder: (context) => BundleScreen(bundleName: bundle.name),
          ),
        );
      },
    );
  }

  _onTapListItem(Bundle bundle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BundleScreen(bundleName: bundle.name),
      ),
    );
  }

  void getDatabaseContent() async {
    _room = await Room().getById(id);
    _headerImage = Image.asset(_room.headerImagePath, fit: BoxFit.cover);

    List<Bundle> bundles = await _room.getBundles().toList();

    if (bundles.length > 0) {
      setState(() {
        _bundles = bundles;
      });
    }
  }
}
