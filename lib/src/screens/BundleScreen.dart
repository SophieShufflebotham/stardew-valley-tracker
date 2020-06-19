import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/src/provider/BundleProvider.dart';
import 'package:test_project/src/provider/ItemProvider.dart';
import '../widgets/SquareAvatar.dart';

class BundleScreen extends StatelessWidget {
  final BundleProvider bundleProvider;

  BundleScreen({@required this.bundleProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BundleProvider>.value(
      value: bundleProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<BundleProvider>(
            builder: (context, provider, _) {
              return Text(provider.bundle.name);
            },
          ),
        ),
        body: Consumer<BundleProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, provider.items[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, ItemProvider itemProvider) {
    return ChangeNotifierProvider.value(
      value: itemProvider,
      child: Consumer<ItemProvider>(builder: (context, provider, _) {
        return ListTile(
          title: Text(provider.item.name),
          leading:
              SquareAvatar(backgroundImage: AssetImage(provider.item.iconPath)),
          trailing: Checkbox(
            activeColor: Colors.green,
            value: provider.item.complete,
            onChanged: (value) {
              provider.complete = value;
            },
          ),
          onTap: () {
            provider.complete = !provider.item.complete;
          },
        );
      }),
    );
  }
}
