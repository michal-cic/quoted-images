import 'package:flutter/material.dart';
import 'package:quoted_images/pages/page_holder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuotedImages',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PageHolder(),
    );
  }
}
