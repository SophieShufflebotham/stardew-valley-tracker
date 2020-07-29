import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/SearchProvider.dart';
import '../widgets/SquareAvatar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class SearchScreen extends StatelessWidget {
  HashMap<int, int> numCompletedByBundles = HashMap<int, int>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
      create: (context) => SearchProvider(),
      child: createSearchBar(context),
    );
  }

  Widget createSearchBar(context) {
    var controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return FloatingSearchBar.builder(
            pinned: true,
            itemCount: provider.items.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < provider.items.length) {
                return _buildListItem(context, provider.items[index], provider);
              }
            },
            controller: controller,
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                provider.searchTerm = '';
                controller.text = '';
              },
            ),
            leading: Icon(Icons.search),
            onChanged: (String value) {
              provider.searchTerm = value;
            },
            body: Text(provider.searchTerm),
            onTap: () {},
            decoration: InputDecoration.collapsed(
              hintText: "Search...",
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(
      context, ItemProvider itemProvider, SearchProvider searchProvider) {
    numCompletedByBundles.putIfAbsent(itemProvider.item.plBundle.id,
        () => itemProvider.item.plBundle.numCompleted);
    return ChangeNotifierProvider.value(
      value: itemProvider,
      builder: (context, child) {
        return Consumer<ItemProvider>(builder: (context, provider, _) {
          var callback = getCallback(provider);

          return ListTile(
            title: Text(provider.item.name),
            subtitle: Text(provider.item.plBundle != null
                ? provider.item.plBundle.name
                : 'CHANGE THIS BUNDLE BROKEN'), //TODO: Broken bundles cause errors here.
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
        });
      },
    );
  }

  Function() getCallback(ItemProvider item) {
    var numCompletedForBundle = numCompletedByBundles[item.item.plBundle.id];
    var bundleCompleted =
        numCompletedForBundle >= item.item.plBundle.numItemsRequired;

    if (bundleCompleted && !item.item.complete) return null;

    return () async {
      item.complete = !item.item.complete;

      if (item.complete) {
        numCompletedByBundles.update(
            item.item.plBundle.id, (currentVal) => currentVal++);
      } else {
        numCompletedByBundles.update(
            item.item.plBundle.id, (currentVal) => currentVal--);
      }
    };
  }
}
