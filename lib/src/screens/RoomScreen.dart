import 'package:flutter/material.dart';

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
          delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 75,
                      color: Colors.black12,
                    ),
                  ),
              childCount: 10),
        )
      ],
    );

    return Scaffold(body: customScrollView);
  }
}
