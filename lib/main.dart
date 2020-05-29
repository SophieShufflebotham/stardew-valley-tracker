// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'List/ListItems.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: Color.fromRGBO(112, 129, 156, 1.0),
    );

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: theme,
      home: ListItems(),
    );
  }
}
