import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  final String _roomName;

  RoomsPage(this._roomName);

  @override
  Widget build(BuildContext context) {
    var assetName = _roomName.toLowerCase().replaceAll(' ', '_');

    Widget appBar = SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(_roomName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: Image.asset(
            "graphics/$assetName.png",
            fit: BoxFit.cover,
          ),
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
