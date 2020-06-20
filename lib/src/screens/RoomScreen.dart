import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/BundleProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/RoomProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/widgets/ListItem.dart';
import 'package:uk.co.tcork.stardew_companion/src/screens/BundleScreen.dart';
import 'package:uk.co.tcork.stardew_companion/model/model.dart';

class RoomScreen extends StatelessWidget {
  final RoomProvider roomProvider;

  RoomScreen({@required this.roomProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: roomProvider,
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
              "${provider.items.where((item) => item.item.complete).length}/${provider.items.length} Completed",
          iconImage: AssetImage(provider.bundle.iconPath),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BundleScreen(bundleProvider: provider),
              ),
            );
          },
        ),
      ),
    );
  }
}
