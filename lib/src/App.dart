import 'package:custom_navigator/custom_scaffold.dart';
import 'package:flutter/material.dart';

import 'screens/HomeScreen.dart';
import 'screens/SearchScreen.dart';

class App extends StatelessWidget {
  var _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('Search'),
    ),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(),
      home: CustomScaffold(
        scaffold: Scaffold(
          bottomNavigationBar: BottomNavigationBar(items: _items),
        ),
        children: <Widget>[
          HomeScreen(),
          SearchScreen(),
        ],
        onItemTap: (index) {},
      ),
    );
  }
}
