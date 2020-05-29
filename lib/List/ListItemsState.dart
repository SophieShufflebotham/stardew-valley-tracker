import 'package:flutter/material.dart';
import '../Rooms/RoomsPage.dart';
import 'ListItems.dart';

class ListItemsState extends State<ListItems> {
  final _bigFontStyle = TextStyle(fontSize: 18, color: Colors.white);
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
      backgroundColor: Color.fromRGBO(112, 129, 156, 1.0),
      bottomNavigationBar: _createNavBar(),
    );
  }

  Widget _createNavBar() {
    return Container(
      height: 50.0,
      child: BottomAppBar(
        color: Color.fromRGBO(112, 129, 156, 1.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
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

  Widget _makeCard(Widget listTile, String roomName) {
    final horizontal = 15.0;
    final vertical = 12.0;

    return Stack(
      children: <Widget>[
        Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(
                horizontal: horizontal, vertical: vertical),
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(146, 157, 176, 1.0)),
              child: listTile,
            )),
        Positioned.fill(
            left: horizontal,
            right: horizontal,
            top: vertical,
            bottom: vertical,
            child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => RoomsPage(roomName),
                    ),
                  );
                })))
      ],
    );
  }

  Widget _buildRoomListItem(String roomName) {
    return ListTile(
      title: Text(
        roomName,
        style: _bigFontStyle,
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, i) {
          final roomName = _rooms[i];
          final listItem = _buildRoomListItem(roomName);
          return _makeCard(listItem, roomName);
        });
  }
}
