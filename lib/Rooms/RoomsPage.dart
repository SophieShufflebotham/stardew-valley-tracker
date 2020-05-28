import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  final String roomName;
  RoomsPage(this.roomName);

  @override
  Widget build(BuildContext context) {
    var titleBar = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("graphics/" + roomName + ".png"), //TODO there's no way this should support spaces - replace them with hyphens?
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: Text(roomName),
          ),
        ),
      ],
    );

    return Scaffold(
        body: Column(
      children: <Widget>[titleBar], //TODO add list-y stuff as big fat widget
    ));
  }
}
