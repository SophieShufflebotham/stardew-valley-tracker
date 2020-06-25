import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/HomeProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/RoomProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/screens/RoomScreen.dart';
import 'package:uk.co.tcork.stardew_companion/src/widgets/ListItem.dart';
import 'package:uk.co.tcork.stardew_companion/tools/populateDb.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Community Center'),
          actions: _buildAppbarActions(context),
        ),
        body: Consumer<HomeProvider>(builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.rooms.length,
            itemBuilder: (context, i) =>
                _buildListItem(context, i, provider.rooms[i]),
          );
        }),
      ),
    );
  }

  List<Widget> _buildAppbarActions(context) {
    return [
      Consumer<HomeProvider>(
        builder: (context, provider, _) => PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'reset',
                child: Text('Reset Data'),
              ),
            ];
          },
          onSelected: (choice) =>
              _onAppbarItemSelected(choice, provider, context),
        ),
      ),
    ];
  }

  void _onAppbarItemSelected(choice, provider, context) {
    if (choice == 'reset') {
      showDialog(
        builder: (context) => AlertDialog(
          title: Text('Reset data'),
          content: Text(
            'Are you sure you would like to reset your data?',
          ),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                await PopulateDb().initialiseDatabase();
                provider.getDatabaseContent();
                Navigator.of(context).pop('modal');
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop('modal');
              },
            )
          ],
        ),
        context: context,
      );
    }
  }

  Widget _buildListItem(
      BuildContext context, int i, RoomProvider roomProvider) {
    return ChangeNotifierProvider.value(
      value: roomProvider,
      child: Consumer<RoomProvider>(
        builder: (context, provider, ___) {
          var completeBundleList = provider.room.plBundles.where((bundle) =>
              bundle.plItems.length ==
              bundle.plItems.where((item) => item.complete).length);

          String subtitle =
              "${completeBundleList.length}/${provider.room.plBundles.length} Completed";

          return ListItem(
            name: provider.room.name,
            subtitle: subtitle,
            iconImage: AssetImage(provider.room.iconPath),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => RoomScreen(
                    roomProvider: provider,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
