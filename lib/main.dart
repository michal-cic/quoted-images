import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/pages/random.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_random.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuotedImages',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<RandomImages>(
            builder: (context) => RandomImages(),
          ),
          ChangeNotifierProvider<RandomQuotes>(
            builder: (context) => RandomQuotes(),
          ),
        ],
        child: Random(),
      ),
    );
  }
}
