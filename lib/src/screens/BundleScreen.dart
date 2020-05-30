import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import '../widgets/SquareAvatar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test_project/model/model.dart';
import 'package:test_project/tools/populateDb.dart';

class BundleScreen extends StatefulWidget {
  final String bundleName;
  final int parentId;

  BundleScreen({this.bundleName, this.parentId});

  @override
  State<StatefulWidget> createState() {
    return BundleScreenState(bundleName: bundleName, parentId: parentId);
  }
}

class BundleScreenState extends State<BundleScreen> {
  final String bundleName;
  final controller = ScrollController();
  final int parentId;

  var titleBar = "";
  var sliverTitle = "";
  List<Item> _items = new List<Item>();
  final Set<String> _savedItems = new Set<String>();
  String headerImagePath = "";

  BundleScreenState({@required this.bundleName, @required this.parentId}) {
    getDatabaseContent();
  }

  @override
  void initState() {
    super.initState();
    bool sliverCollapsed = false;
    bool initialised = false;

    if (!initialised) {
      sliverTitle = bundleName;
      initialised = true;
    }

    controller.addListener(() {
      if (controller.offset > 220 && !controller.position.outOfRange) {
        if (!sliverCollapsed) {
          // do what ever you want when silver is collapsing !

          titleBar = bundleName;
          sliverTitle = "";
          sliverCollapsed = true;
          setState(() {});
        }
      } else if (controller.offset <= 220 && !controller.position.outOfRange) {
        if (sliverCollapsed) {
          // do what ever you want when silver is expanding !

          sliverTitle = bundleName;
          titleBar = "";
          sliverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  void _clickHandler(bool alreadySaved, String itemName, int itemId) {
    setState(() {
      if (alreadySaved) {
        _savedItems.remove(itemName);
        toggleItemSelected(itemId, false);
      } else {
        _savedItems.add(itemName);
        toggleItemSelected(itemId, true);
      }
    });
  }

  Widget _buildListItem(BuildContext context, int i) {
    var itemName = _items[i].name;
    var itemId = _items[i].id;
    var imageName = itemName.toLowerCase().replaceAll(' ', '_') + "_icon";
    bool alreadySaved = _savedItems.contains(itemName);
    var image = AssetImage("graphics/$imageName.png");
    
    bool alreadySaved =
        (_items[i].complete == null) ? false : _items[i].complete;

    return ListTile(
        title: Text(itemName),
        leading: SquareAvatar(backgroundImage: image),
        trailing: Switch(
          activeColor: Colors.lightGreen,
          value: alreadySaved,
          onChanged: (value) {
            _clickHandler(alreadySaved, itemName, itemId);
          },
        ),
        onTap: () {
          _clickHandler(alreadySaved, itemName, itemId);
        });
  }

  @override
  Widget build(BuildContext context) {
    var assetName = bundleName.toLowerCase().replaceAll(' ', '_');

    Widget appBar = SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        title: Text(titleBar,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        flexibleSpace: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.7), BlendMode.modulate),
                  child: Image.asset("graphics/$assetName.png",
                      fit: BoxFit.cover)),
            ),
            FlexibleSpaceBar(
                title: Text(sliverTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ))),
          ],
        ));

    Widget customScrollView = CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        appBar,
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < _items.length) {
              return _buildListItem(context, index);
            }
          }),
        )
      ],
    );

    return Scaffold(body: customScrollView);
  }

  void getDatabaseContent() async {
    Bundle currentBundle = await Bundle().getById(parentId);
    headerImagePath = currentBundle.headerImagePath;
    List<Item> items = await currentBundle.getItems().toList();

    if (items.length > 0) {
      setState(() {
        _items = items;
      });
    }
  }

  void toggleItemSelected(itemId, itemSelected) async {
    await Item(id: itemId, complete: itemSelected).save();
    Bundle currentBundle = await Bundle().getById(parentId);
    List<Item> items = await currentBundle.getItems().toList();

    if (items.length > 0) {
      setState(() {
        _items = items;
      });
    }
  }
}
