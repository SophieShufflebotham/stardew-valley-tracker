import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;

  RoomScreen({this.roomName});

  @override
  State<StatefulWidget> createState() {
    return RoomScreenState(roomName: roomName);
  }
}

class RoomScreenState extends State<RoomScreen> {
  final String roomName;
  final controller = ScrollController();
  var titleBar = "";
  var sliverTitle = "";
  final _bundles = [
    "Spring Foraging Bundle",
    "Summer Foraging Bundle",
  ];

  RoomScreenState({@required this.roomName});

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
    var bundleName = _bundles[i];
    var imageName = bundleName.toLowerCase().replaceAll(' ', '_') + "_icon";

    return ListItem(
      name: bundleName,
      iconImage: AssetImage("graphics/$imageName.png"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => BundleScreen(bundleName: bundleName),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var assetName = roomName.toLowerCase().replaceAll(' ', '_');

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
                  child: Image.asset("graphics/$assetName.png",
                      fit: BoxFit.cover)),
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
}
