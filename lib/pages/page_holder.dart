import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/pages/random.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_random.dart';

class PageHolder extends StatefulWidget {
  @override
  _PageHolderState createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RandomImages>(
          builder: (context) => RandomImages(),
        ),
        ChangeNotifierProvider<RandomQuotes>(
          builder: (context) => RandomQuotes(),
        ),
      ],
      child: Random(),
    );
  }
}
