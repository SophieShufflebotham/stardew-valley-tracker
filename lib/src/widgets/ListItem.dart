import 'package:flutter/material.dart';

import 'SquareAvatar.dart';

class ListItem extends StatelessWidget {
  final String name;
  final GestureTapCallback onTap;
  final ImageProvider iconImage;

  ListItem({
    @required this.name,
    @required this.onTap,
    @required this.iconImage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(name),
        subtitle: Text('0/6 Completed'),
        trailing: Icon(Icons.keyboard_arrow_right),
        leading: SquareAvatar(backgroundImage: iconImage),
        onTap: onTap);
  }
}
