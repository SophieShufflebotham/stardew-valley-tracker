import 'package:flutter/material.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import '../widgets/SquareAvatar.dart';
import 'package:flutter/services.dart' show rootBundle;

class BundleScreen extends StatefulWidget {
  final String bundleName;

  BundleScreen({this.bundleName});

  @override
  State<StatefulWidget> createState() {
    return BundleScreenState(bundleName: bundleName);
  }
}

class BundleScreenState extends State<BundleScreen> {
  final String bundleName;
  final controller = ScrollController();
  var titleBar = "";
  var sliverTitle = "";
  final _items = [
    "Dandelion",
    "Wild Horseradish",
  ];
  final Set<String> _savedItems = new Set<String>();

  BundleScreenState({@required this.bundleName});

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

  void _clickHandler(bool alreadySaved, String itemName) {
    setState(() {
      if (alreadySaved) {
        _savedItems.remove(itemName);
      } else {
        _savedItems.add(itemName);
      }
    });
  }

  Widget _buildListItem(BuildContext context, int i) {
    var itemName = _items[i];
    var imageName = itemName.toLowerCase().replaceAll(' ', '_') + "_icon";

    bool alreadySaved = _savedItems.contains(itemName);
    var image = AssetImage("graphics/$imageName.png");

    return ListTile(
        title: Text(itemName),
        leading: SquareAvatar(backgroundImage: image),
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
}
