import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/tools/populateDb.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;
  final int parentId;

  RoomScreen({this.roomName, this.parentId});

  @override
  State<StatefulWidget> createState() {
    return RoomScreenState(roomName: roomName, parentId: parentId);
  }
}

class RoomScreenState extends State<RoomScreen> {
  final String roomName;
  final int parentId;
  int bundleId;
  String assetPath = "";

  final controller = ScrollController();
  var titleBar = "";
  var sliverTitle = "";
  List<Bundle> _bundles = new List();

  RoomScreenState({@required this.roomName, @required this.parentId}) {
    getDatabaseContent();
  }

  @override
  void initState() {
    super.initState();
    bool sliverCollapsed = false;
    bool initialised = false;

    if (!initialised) {
      sliverTitle = roomName;
      initialised = true;
    }

    controller.addListener(() {
      if (controller.offset > 220 && !controller.position.outOfRange) {
        if (!sliverCollapsed) {
          // do what ever you want when silver is collapsing !

          titleBar = roomName;
          sliverTitle = "";
          sliverCollapsed = true;
          setState(() {});
        }
      }
      if (controller.offset <= 220 && !controller.position.outOfRange) {
        if (sliverCollapsed) {
          // do what ever you want when silver is expanding !

          sliverTitle = roomName;
          titleBar = "";
          sliverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _bundles.length, itemBuilder: _buildListItem);
  }

  Widget _buildListItem(BuildContext context, int i) {
    var bundleName = _bundles[i].name;
    var imagePath = _bundles[i].iconPath;
    var bundleId = _bundles[i].id;
    var iconImage;

    try {
      //iconImage = AssetImage(imagePath);
    } catch (e) {
      print("exceptionHandled");
      iconImage = AssetImage("graphics/placeholder.png");
    }
    return ListItem(
      name: bundleName,
      iconImage: iconImage,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                BundleScreen(bundleName: bundleName, parentId: bundleId),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var assetName = roomName.toLowerCase().replaceAll(' ', '_');
    Widget assetIcon;

    try {
      assetIcon = Image.asset(assetPath, fit: BoxFit.cover);
    } catch (e) {
      print("exceptionHandled");
      assetIcon = Image.asset("graphics/placeholder.png", fit: BoxFit.cover);
    }

    try {
      assetIcon = Image.asset("graphics/$assetName.png", fit: BoxFit.cover);
    } catch (e) {
      print("exceptionHandled");
      assetIcon = Image.asset("graphics/placeholder.png", fit: BoxFit.cover);
    }

    Widget appBar = SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        title: Text(titleBar,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        flexibleSpace: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.7), BlendMode.modulate),
                  child: assetIcon),
            ),
            FlexibleSpaceBar(
                title: Text(sliverTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ))),
          ],
        ));

    Widget customScrollView = CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        appBar,
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < _bundles.length) {
              return _buildListItem(context, index);
            }
          }),
        )
      ],
    );

    return Scaffold(body: customScrollView);
  }

  void getDatabaseContent() async {
    Room currentRoom = await Room().getById(parentId);
    assetPath = currentRoom.headerImagePath;
    List<Bundle> bundles = await currentRoom.getBundles().toList();

    if (bundles.length > 0) {
      setState(() {
        _bundles = bundles;
      });
    }
  }
}
