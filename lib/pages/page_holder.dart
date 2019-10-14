import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/pages/random.dart';
import 'package:quoted_images/providers/images.dart';
import 'package:quoted_images/providers/quotes_random.dart';

class PageHolder extends StatefulWidget {
  @override
  _PageHolderState createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  List<Widget> pages;

  @override
  void initState() {
    ChangeNotifierProvider<CustomImageProvider> imageProvider = ChangeNotifierProvider<CustomImageProvider>(
      builder: (context) => CustomImageProvider(),
    );

    pages = [
      MultiProvider(
        providers: [
          imageProvider,
          ChangeNotifierProvider<RandomQuotes>(
            builder: (context) => RandomQuotes(),
          ),
        ],
        child: Random(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
    );
  }
}
