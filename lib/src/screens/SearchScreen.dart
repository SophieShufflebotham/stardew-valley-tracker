import 'package:flutter/material.dart';
import '../widgets/SquareAvatar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:test_project/model/model.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  List<Item> _searchResults = new List<Item>();
  final Set<String> _savedItems = new Set<String>();
  var _padding = 20.0;
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createSearchBar(),
    );
  }

  Widget createSearchBar() {
    controller.addListener(_handleSearch);

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
                setState(() {
                  _searchResults.clear();
                });
              }),
          leading: Icon(Icons.search),
          onChanged: (String value) {},
          onTap: () {},
          decoration: InputDecoration.collapsed(
            hintText: "Search...",
          ),
        ));

    return searchBar;
  }

  Widget _buildListItem(context, index) {
    Item item = _searchResults[index];
    var itemName = _searchResults[index].name;
    var imageName = itemName.toLowerCase().replaceAll(' ', '_') + "_icon";
    bool alreadySaved = _searchResults[index].complete;

    return ListTile(
        title: Text(item.name),
        leading: SquareAvatar(
            backgroundImage: AssetImage("graphics/$imageName.png")),
        trailing: Switch(
          activeColor: Colors.lightGreen,
          value: alreadySaved,
          onChanged: (value) {},
        ),
        onTap: () {
          toggleItemComplete(item);
        });
  }

  void _handleSearch() {
    String enteredText = controller.text;
    print("text: " + enteredText);
    if (enteredText != "") {
      _searchForText(enteredText);
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _searchForText(String text) async {
    List<Item> results =
        await Item().select().name.contains("%$text%").toList();

    setState(() {
      _searchResults = results;
    });
  }

  void toggleItemComplete(Item item) async {
    setState(() {
      item.complete = !item.complete;
      item.save();
    });
  }
}
