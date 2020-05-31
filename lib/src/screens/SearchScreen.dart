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
  List<Item> _items = new List<Item>();
  List<Bundle> _bundles = new List<Bundle>();

  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getItemsFromDatabase();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createSearchBar(),
    );
  }

  Widget createSearchBar() {
    controller.addListener(_handleSearch);

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: FloatingSearchBar.builder(
        controller: controller,
        pinned: true,
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < _searchResults.length) {
            return _buildListItem(context, index);
          }
        },
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            controller.clear();
          },
        ),
        leading: Icon(Icons.search),
        onChanged: (String value) {},
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
      ),
    );
  }

  Widget _buildListItem(context, index) {
    Item item = _searchResults[index];
    Bundle bundle = _bundles.firstWhere((bundle) => bundle.id == item.bundle);

    return ListTile(
      title: Text(item.name),
      subtitle: Text(bundle.name),
      leading: SquareAvatar(
        backgroundImage: AssetImage(item.iconPath),
        backgroundColor: Theme.of(context).accentColor,
      ),
      trailing: Switch(
        activeColor: Colors.lightGreen,
        value: item.complete,
        onChanged: (value) {
          toggleItemComplete(item);
        },
      ),
      onTap: () {
        toggleItemComplete(item);
      },
    );
  }

  void _handleSearch() {
    if (controller.text.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
    } else {
      _searchForText(controller.text);
    }
  }

  void _searchForText(String text) async {
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(_items.where(
          (item) => item.name.toLowerCase().contains(text.toLowerCase())));
    });
  }

  void toggleItemComplete(Item item) async {
    setState(() {
      item.complete = !item.complete;
      item.save();
    });
  }

  void _getItemsFromDatabase() async {
    _items = await Item().select().toList();
    _bundles = await Bundle().select().toList();
    _searchForText(controller.text);
  }
}
