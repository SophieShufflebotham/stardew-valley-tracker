import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/src/provider/BundleProvider.dart';
import 'package:test_project/src/provider/RoomProvider.dart';
import 'package:test_project/src/widgets/ListItem.dart';
import 'package:test_project/src/screens/BundleScreen.dart';
import 'package:test_project/model/model.dart';

class RoomScreen extends StatelessWidget {
  final Room room;
  List<Bundle> _bundles = new List();

  RoomScreen({@required this.room});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoomProvider>(
      create: (context) => RoomProvider(room),
      child: Scaffold(
        appBar: new AppBar(
          title: Consumer<RoomProvider>(
            builder: (context, provider, _) => Text(provider.room.name),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Consumer<RoomProvider>(
          builder: (context, provider, value) {
            return ListView.builder(
                itemCount: provider.bundles.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, provider.bundles[index]);
                });
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, BundleProvider bundleProvider) {
    return ChangeNotifierProvider.value(
      value: bundleProvider,
      child: Consumer<BundleProvider>(
        builder: (context, provider, child) => ListItem(
          name: provider.bundle.name,
          subtitle:
              "${provider.bundle.plItems.where((item) => item.complete).length}/${provider.bundle.plItems.length} Completed",
          iconImage: AssetImage(provider.bundle.iconPath),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BundleScreen(bundle: provider.bundle),
              ),
            );
          },
        ),
      ),
    );
  }
}
