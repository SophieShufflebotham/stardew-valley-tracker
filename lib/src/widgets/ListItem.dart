import 'package:flutter/material.dart';

import 'SquareAvatar.dart';

class ListItem extends StatelessWidget {
  final String name;
  final GestureTapCallback onTap;
  final ImageProvider iconImage;
  final String subtitle;

  ListItem(
      {@required this.name,
      @required this.onTap,
      @required this.iconImage,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(name),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.keyboard_arrow_right),
        leading: SquareAvatar(backgroundImage: iconImage),
        onTap: onTap);
  }
}
