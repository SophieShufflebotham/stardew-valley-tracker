import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';

import 'screens/HomeScreen.dart';
import 'screens/SearchScreen.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  final _screens = [
    HomeScreen(),
    SearchScreen(),
  ];

  int _currentIndex = 0;
  var _page;

  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    _page = _page ?? _screens[0];

    var _items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
    ];

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          selectedItemColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: (index) {
            navigatorKey.currentState
                .popUntil((_) => !navigatorKey.currentState.canPop());
            navigatorKey.currentState.maybePop();

            setState(() {
              _currentIndex = index;
              _page = _screens[index];
            });
          },
        ),
        body: CustomNavigator(
          navigatorKey: navigatorKey,
          home: _page,
          pageRoute: PageRoutes.materialPageRoute,
        ),
      ),
    );
  }

  ours(index) {
    navigatorKey.currentState.maybePop();
    setState(() => _page = _screens[index]);
    _currentIndex = index;
  }

  zero3(index) {
    navigatorKey.currentState
        .popUntil((_) => !navigatorKey.currentState.canPop());
    navigatorKey.currentState.maybePop();

    setState(() => _currentIndex = index);
    // widget.onItemTap(index);
  }
}
