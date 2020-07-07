import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/BundleProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';
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
                var bundleComplete = provider.bundle.numItemsRequired <=
                    provider.bundle.plItems
                        .where((item) => item.complete)
                        .length;
                return _buildListItem(
                    context, provider.items[index], bundleComplete);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, ItemProvider itemProvider, bool bundleComplete) {
    return ChangeNotifierProvider.value(
      value: itemProvider,
      child: Consumer<ItemProvider>(builder: (context, provider, _) {
        var callback = getItemTappedCallback(bundleComplete, provider);

        return ListTile(
          title: Text(provider.item.name),
          leading: SquareAvatar(
            backgroundImage: AssetImage(provider.item.iconPath),
          ),
          trailing: Checkbox(
            activeColor: Colors.green,
            value: provider.item.complete,
            onChanged: callback == null ? null : (value) => callback(),
          ),
          onTap: callback,
        );
      }),
    );
  }

  void Function() getItemTappedCallback(bundleComplete, provider) {
    if (bundleComplete && !provider.complete) return null;

    return () {
      provider.complete = !provider.item.complete;
    };
  }
}
