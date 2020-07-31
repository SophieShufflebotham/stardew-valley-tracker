import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/model/model.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/SearchProvider.dart';
import '../widgets/SquareAvatar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class SearchScreen extends StatelessWidget {
  Map numCompletedByBundles;
  SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    numCompletedByBundles = new Map();
    return ChangeNotifierProvider<SearchProvider>.value(
      value: searchProvider = new SearchProvider(),
      child: createSearchBar(context),
    );
  }

  Widget createSearchBar(context) {
    var controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            var colour = Theme.of(context).hintColor;
            var spinkit = SpinKitThreeBounce(
              color: colour,
              size: 50.0,
            );
            return spinkit;
          }
          return FloatingSearchBar.builder(
            pinned: true,
            itemCount: provider.items.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < provider.items.length) {
                return _buildListItem(context, provider.items[index], provider);
              }
              return null;
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
    BuildContext context,
    ItemProvider itemProvider,
    SearchProvider searchProvider,
  ) {
    var bundle = itemProvider.item.plBundle;
    if (!numCompletedByBundles.containsKey(bundle.id)) {
      numCompletedByBundles[bundle.id] = bundle.numCompleted;
    }

    return ChangeNotifierProvider.value(
      value: itemProvider,
      builder: (context, child) {
        return Consumer<ItemProvider>(builder: (context, provider, _) {
          var callback = _getCallback;

          var item = provider.item;
          var bundle = item.plBundle;

          return ListTile(
            title: Text(item.name),
            subtitle: Text(
              bundle != null
                  ? bundle.name
                  : 'Bundle unknown - Unexpected error',
            ), //TODO: Broken bundles cause errors here.
            leading: SquareAvatar(
              backgroundImage: AssetImage(item.iconPath),
            ),
            trailing: Checkbox(
              tristate: true,
              value: searchProvider.completionStatuses[item.id],
              activeColor: searchProvider.completionStatuses[item.id] == null
                  ? Colors.grey
                  : Colors.green,
              onChanged: callback == null
                  ? null
                  : (value) => callback(provider, value)(),
            ),
            onTap: callback(provider, null),
          );
        });
      },
    );
  }

  Function() _getCallback(ItemProvider item, bool value) {
    var bundle = item.item.plBundle;
    var numCompletedForBundle = numCompletedByBundles[bundle.id];
    var bundleCompleted = numCompletedForBundle >= bundle.numItemsRequired;

    if (bundleCompleted && !item.complete) {
      return null; //item.item.complete
    }

    return () async {
      item.complete = !item.complete; //item.item.complete

      var currentItem = item.item;
      var bundle = item.item.plBundle;

      if (item.complete) {
        numCompletedByBundles[bundle.id]++;
        searchProvider.updateCompletionStatus(currentItem.id, true);
      } else {
        numCompletedByBundles[bundle.id]--;
        searchProvider.updateCompletionStatus(currentItem.id, false);
      }

      bundle.numCompleted = numCompletedByBundles[bundle.id];
      await bundle.save();
      _updateBundleCompletionStatuses(bundle, currentItem.id, item.complete);
    };
  }

  _updateBundleCompletionStatuses(
      Bundle bundle, int currentItemId, bool itemComplete) async {
    var bundleCompleted = numCompletedByBundles[bundle.id] >=
        bundle.numItemsRequired; //Use the updated completion amount

    var otherItemsInBundleObject = await bundle.getItems().toList();
    List<int> otherItemsInBundle = new List();
    for (var oItem in otherItemsInBundleObject) {
      otherItemsInBundle.add(oItem.id);
    }

    if (bundleCompleted && itemComplete) {
      for (var entry in searchProvider.completionStatuses.entries) {
        if (otherItemsInBundle.contains(entry.key) &&
            entry.key != currentItemId) {
          if (searchProvider.completionStatuses[entry.key] != true) {
            searchProvider.updateCompletionStatus(entry.key, null);
          }
        }
      }
    } else {
      for (var entry in searchProvider.completionStatuses.entries) {
        if (otherItemsInBundle.contains(entry.key) &&
            searchProvider.completionStatuses[entry.key] == null) {
          //Re-enable disabled checkboxes
          searchProvider.updateCompletionStatus(entry.key, false);
        }
      }
    }
  }
}
