import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/ItemProvider.dart';
import 'package:uk.co.tcork.stardew_companion/src/provider/SearchProvider.dart';
import '../widgets/SquareAvatar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class SearchScreen extends StatelessWidget {
  //HashMap<int, int> numCompletedByBundles = HashMap<int, int>();
  //var completionStatuses = new Map();
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
    if (!numCompletedByBundles.containsKey(itemProvider.item.plBundle.id)) {
      numCompletedByBundles[itemProvider.item.plBundle.id] =
          itemProvider.item.plBundle.numCompleted;
    }
    return ChangeNotifierProvider.value(
      value: itemProvider,
      builder: (context, child) {
        return Consumer<ItemProvider>(builder: (context, provider, _) {
          var callback = getCallback;

          return ListTile(
            title: Text(provider.item.name),
            subtitle: Text(provider.item.plBundle != null
                ? provider.item.plBundle.name
                : 'CHANGE THIS BUNDLE BROKEN'), //TODO: Broken bundles cause errors here.
            leading: SquareAvatar(
              backgroundImage: AssetImage(provider.item.iconPath),
            ),
            trailing: Checkbox(
              tristate: true,
              value: searchProvider.completionStatuses[provider.item.id],
              activeColor:
                  searchProvider.completionStatuses[provider.item.id] == null
                      ? Colors.grey
                      : Colors.green,
              onChanged: callback == null
                  ? null
                  : (value) => callback(provider, value),
            ),
            onTap: callback(provider, null),
          );
        });
      },
    );
  }

  Function() getCallback(ItemProvider item, bool value) {
    var numCompletedForBundle = numCompletedByBundles[item.item.plBundle.id];
    var bundleCompleted =
        numCompletedForBundle >= item.item.plBundle.numItemsRequired;

    if (bundleCompleted && !item.item.complete) {
      return null;
    }

    return () async {
      item.complete = !item.item.complete;

      if (item.complete) {
        numCompletedByBundles[item.item.plBundle.id]++;
        searchProvider.updateCompletionStatus(item.item.id, true);
      } else {
        numCompletedByBundles[item.item.plBundle.id]--;
        searchProvider.updateCompletionStatus(item.item.id, false);
      }

      item.item.plBundle.numCompleted =
          numCompletedByBundles[item.item.plBundle.id];
      await item.item.plBundle.save();

      bundleCompleted = numCompletedByBundles[item.item.plBundle.id] >=
          item.item.plBundle
              .numItemsRequired; //Use the updated completion amount

      var otherItemsInBundleObject =
          await item.item.plBundle.getItems().toList();
      List<int> otherItemsInBundle = new List();
      for (var i in otherItemsInBundleObject) {
        otherItemsInBundle.add(i.id);
      }

      if (bundleCompleted && item.complete) {
        for (var key in searchProvider.completionStatuses.entries) {
          if (otherItemsInBundle.contains(key.key) && key.key != item.item.id) {
            if (searchProvider.completionStatuses[key.key] != true) {
              searchProvider.updateCompletionStatus(key.key, null);
            }
          }
        }
      } else {
        for (var key in searchProvider.completionStatuses.entries) {
          if (otherItemsInBundle.contains(key.key) &&
              searchProvider.completionStatuses[key.key] == null) {
            //Re-enable disabled checkboxes
            searchProvider.updateCompletionStatus(key.key, false);
          }
        }
      }
    };
  }
}
