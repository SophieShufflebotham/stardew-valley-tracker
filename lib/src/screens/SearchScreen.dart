import 'package:flutter/material.dart';
import '../widgets/SquareAvatar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  var _searchResults = ["Wild Horseradish", "Dandelion"];
  final Set<String> _savedItems = new Set<String>();
  var _padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createSearchBar(),
    );
  }

  Widget createSearchBar() {
    var controller = TextEditingController();

    var textField = Expanded(
        flex: 2,
        child: Padding(
            padding: EdgeInsets.only(left: _padding, bottom: _padding),
            child: TextField(
              controller: controller,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.search), hintText: 'Search'),
              onTap: () {
                setState(() {});
              },
            )));

    // var searchBar = Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: <Widget>[textField, eraseTextIcon],
    // );
    var searchBar = Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: FloatingSearchBar.builder(
          controller: controller,
          pinned: true,
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            if (index < _searchResults.length) {
              return _buildListItem(context, index);
            }
          },
          trailing: IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                controller.clear();
              }),
          leading: Icon(Icons.search),
          onChanged: (String value) {},
          onTap: () {},
          decoration: InputDecoration.collapsed(
            hintText: "Search...",
          ),
        ));

    var customScrollView = CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: searchBar),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < _searchResults.length) {
              return _buildListItem(context, index);
            }
          }),
        )
      ],
    );

    return searchBar;
  }

  Widget _buildListItem(context, index) {
    var itemName = _searchResults[index];
    var imageName = itemName.toLowerCase().replaceAll(' ', '_') + "_icon";
    bool alreadySaved = _savedItems.contains(itemName);

    return ListTile(
        title: Text(itemName),
        leading: SquareAvatar(
            backgroundImage: AssetImage("graphics/$imageName.png")),
        trailing: Switch(
          activeColor: Colors.lightGreen,
          value: alreadySaved,
          onChanged: (value) {
            _clickHandler(alreadySaved, itemName);
          },
        ),
        onTap: () {
          _clickHandler(alreadySaved, itemName);
        });
  }

  void _clickHandler(bool alreadySaved, String itemName) {
    setState(() {
      if (alreadySaved) {
        _savedItems.remove(itemName);
      } else {
        _savedItems.add(itemName);
      }
    });
  }
}
