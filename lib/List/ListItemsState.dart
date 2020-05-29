import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import '../Rooms/RoomsPage.dart';
import 'ListItems.dart';

class ListItemsState extends State<ListItems> {
  final Set<String> _saved = Set<String>();
  final _rooms = [
    "Crafts Room",
    "Boiler Room",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stardew Valley Checklist"),
      ),
      body: _buildList(),
      bottomNavigationBar: _createNavBar(),
    );
  }

  Widget _createNavBar() {
    return Container(
      height: 50.0,
      child: BottomAppBar(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _navigateToSearch,
              ),
            ]),
      ),
    );
  }

  Widget _builder(BuildContext context) {
    final Iterable<ListTile> tiles = _saved.map(
      (String listString) {
        return ListTile(
          title: Text(listString),
        );
      },
    );

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: ListView(children: divided),
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: _builder,
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, i) {
          var roomName = _rooms[i];
          var imageName = roomName.toLowerCase().replaceAll(' ', '_') + "_icon";

          return ListItem(
            name: roomName,
            iconImage: AssetImage("graphics/$imageName.png"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => RoomsPage(roomName),
                ),
              );
            },
          );
        });
  }
}
