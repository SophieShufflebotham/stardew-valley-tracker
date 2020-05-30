import 'package:flutter/material.dart';
import 'package:test_project/src/screens/RoomScreen.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/model/model.dart';
import 'package:test_project/tools/populateDb.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Room> _rooms = new List<Room>();

  HomeScreenState() {
    getDatabaseContent();
  }
  
  static final String pageTitle = "Community Center";
  var imageName = pageTitle.toLowerCase().replaceAll(' ', '_') + "_icon";
  var sliverTitle = "";
  var titleBar = "";
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
    bool sliverCollapsed = false;
    bool initialised = false;

    if (!initialised) {
      sliverTitle = pageTitle;
      initialised = true;
    }

    controller.addListener(() {
      if (controller.offset > 220 && !controller.position.outOfRange) {
        if (!sliverCollapsed) {
          // do what ever you want when silver is collapsing !

          titleBar = pageTitle;
          sliverTitle = "";
          sliverCollapsed = true;
          setState(() {});
        }
      } else if (controller.offset <= 220 && !controller.position.outOfRange) {
        if (sliverCollapsed) {
          // do what ever you want when silver is expanding !

          sliverTitle = pageTitle;
          titleBar = "";
          sliverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var assetName = pageTitle.toLowerCase().replaceAll(' ', '_');

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
            if (index < _rooms.length) {
              return _buildListItem(context, index);
            }
          }),
        )
      ],
    );

    return Scaffold(body: customScrollView);
  }

  Widget _buildList() {
    Widget retVal =
        ListView.builder(itemCount: _rooms.length, itemBuilder: _buildListItem);

    return retVal;
  }

  Widget _buildListItem(BuildContext context, int i) {
    var roomName = _rooms[i].name;
    var roomId = _rooms[i].id;
    var imageName = roomName.toLowerCase().replaceAll(' ', '_') + "_icon";
    return ListItem(
      name: roomName,
      iconImage: AssetImage("graphics/placeholder.png"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                RoomScreen(roomName: roomName, parentId: roomId),
          ),
        );
      },
    );
  }

  void getDatabaseContent() async {
    bool success = await PopulateDb().populateRooms();
    if (success) {
      List<Room> roomsList = await Room().select().toList();

      setState(() {
        _rooms = roomsList;
      });
    }
  }
}
