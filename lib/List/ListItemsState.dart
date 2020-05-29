import 'package:flutter/material.dart';
import '../Rooms/RoomsPage.dart';
import 'ListItems.dart';

class ListItemsState extends State<ListItems> {
  final _bigFontStyle = TextStyle(fontSize: 18, color: Colors.white);
  final Set<String> _saved = Set<String>();
  final _listContent = new List();
  final List<String> _rooms = new List();
  int _maxRoomsLength =
      2; //TODO number of rooms total - This can probably be grabbed from a file/somewhere else?

  @override
  Widget build(BuildContext context) {
    //var _icon = IconButton(icon: Icon(Icons.list), onPressed: _pushSaved);

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
                onPressed: () {}, //TODO
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: _pushSaved, //TODO
              ),
            ]),
      ),
    );
  }

  List _populateListEntries() {
    List _list = new List();
    for (int i = 0; i < _maxRoomsLength; i++) {
      _setRoomName(i);
      _list.add(_rooms[i]);
    }
    return _list;
  }

//TODO get the data from somewhere non-hardcoded
  void _setRoomName(int index) {
    switch (index) {
      case 0:
        _rooms.add("Crafts Room");
        break;
      case 1:
        _rooms.add("Boiler Room");
        break;
      default:
        _rooms.add("Error Room");
    }
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

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: _builder,
      ),
    );
  }

  Widget _iconConfig(bool alreadySaved) {
    // return Icon(
    //   alreadySaved ? Icons.bookmark : Icons.bookmark_border,
    //   color: alreadySaved ? Colors.white : null,
    // );
    return Icon(Icons.keyboard_arrow_right);
  }

  Widget _makeCard(var listTile) {
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(146, 157, 176, 1.0)),
          child: listTile,
        ));
  }

  Widget _makeListTile(String listString, bool alreadySaved) {
    return ListTile(
      title: Text(
        listString,
        style: _bigFontStyle,
      ),
      trailing: _iconConfig(alreadySaved),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => RoomsPage(listString),
          ),
        );
      },
    ); //TODO
  }

  Widget _buildList() {
    print("Length: " + _rooms.length.toString());
    return ListView.builder(
        itemCount: _maxRoomsLength,
        itemBuilder: (context, i) {
          print("i: " + i.toString());
          print("rooms: " + _rooms.length.toString());
          print("true: " + (i >= _rooms.length).toString());

          if (i >= _rooms.length) {
            print("wtf");
            _listContent.addAll(_populateListEntries());
          }

          final listString = _listContent[i];
          final bool alreadySaved = _saved.contains(listString);
          var _listTile = _makeListTile(listString, alreadySaved);
          return _makeCard(_listTile);
        });
  }
}
