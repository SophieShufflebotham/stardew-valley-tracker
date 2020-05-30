import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/FilteredHeaderImage.dart';
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
  final int id;
  Widget _headerImage;
  Map<int, ImageProvider> _iconImages = Map<int, ImageProvider>();
  bool _sliverCollapsed = false;

  final controller = ScrollController();
  var titleBar = "";
  var sliverTitle = "";
  List<Bundle> _bundles = new List();

  RoomScreenState({
    @required this.id,
  }) {
    sliverTitle = _room.name;
    getDatabaseContent();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (controller.offset > 220 &&
        !controller.position.outOfRange &&
        !_sliverCollapsed) {
      titleBar = _room.name;
      sliverTitle = "";
      _sliverCollapsed = true;
      setState(() {});
    } else if (controller.offset <= 220 &&
        !controller.position.outOfRange &&
        _sliverCollapsed) {
      sliverTitle = _room.name;
      titleBar = "";
      _sliverCollapsed = false;
      setState(() {});
    }
  }

  _onTapListItem(Bundle bundle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BundleScreen(bundleName: bundle.name),
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
      name: bundle.name,
      iconImage: _iconImages[bundle.id],
      onTap: () {
        _onTapListItem(bundle);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var title = Text(
      titleBar,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );

    var sliverTitleText = Text(
      sliverTitle,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );

    Widget appBar = SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      title: title,
      flexibleSpace: Stack(
        children: <Widget>[
          FilteredHeaderImage(child: _headerImage),
          FlexibleSpaceBar(title: sliverTitleText),
        ],
      ),
    );

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
      body: CustomScrollView(
        controller: controller,
        slivers: [appBar, listSliver],
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
