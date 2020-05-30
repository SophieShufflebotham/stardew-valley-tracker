import 'package:flutter/material.dart';

import 'FilteredHeaderImage.dart';

class ImageHeader extends StatefulWidget {
  String title = "_";
  Image image;
  List<Widget> slivers;

  ImageHeader({
    @required this.title,
    @required this.image,
    @required this.slivers,
  });

  final controller = ScrollController();

  @override
  State<StatefulWidget> createState() {
    return ImageHeaderState(title: title, image: image, slivers: slivers);
  }
}

class ImageHeaderState extends State<ImageHeader> {
  String title = "_";
  Image image;
  List<Widget> slivers;

  String _titleBar = "";
  String _sliverTitle = "";

  ImageHeaderState({
    @required this.title,
    @required this.image,
    @required this.slivers,
  }) {
    _sliverTitle = title;
  }

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  bool _sliverCollapsed = false;

  _scrollListener() {
    if (controller.offset > 220 &&
        !controller.position.outOfRange &&
        !_sliverCollapsed) {
      _titleBar = title;
      _sliverTitle = "";
      _sliverCollapsed = true;
      setState(() {});
    } else if (controller.offset <= 220 &&
        !controller.position.outOfRange &&
        _sliverCollapsed) {
      _sliverTitle = title;
      _titleBar = "";
      _sliverCollapsed = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = Text(
      _titleBar,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );

    var sliverTitleText = Text(
      _sliverTitle,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );

    Widget appBar = SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      title: title,
      flexibleSpace: Stack(
        children: <Widget>[
          FilteredHeaderImage(child: image),
          FlexibleSpaceBar(title: sliverTitleText),
        ],
      ),
    );

    var addSlivers = [appBar];

    addSlivers.addAll(slivers);

    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: addSlivers,
      ),
    );
  }
}
