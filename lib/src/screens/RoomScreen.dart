import 'package:flutter/material.dart';

class RoomScreen extends StatelessWidget {
  final String roomName;

  RoomScreen({@required this.roomName});

  @override
  Widget build(BuildContext context) {
    var assetName = roomName.toLowerCase().replaceAll(' ', '_');

    Widget appBar = SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(roomName,
              style: TextStyle(
                fontSize: 16.0,
              )),
          background: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.7), BlendMode.modulate),
              child: Image.asset("graphics/$assetName.png", fit: BoxFit.cover)),
          collapseMode: CollapseMode.none,
        ));

    Widget customScrollView = CustomScrollView(
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
