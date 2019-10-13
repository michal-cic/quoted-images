import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/pages/favorites.dart';
import 'package:quoted_images/pages/random.dart';
import 'package:quoted_images/providers/images_favorite.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_favorite.dart';
import 'package:quoted_images/providers/quotes_random.dart';

class PageHolder extends StatefulWidget {
  @override
  _PageHolderState createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  List<Widget> pages;

  @override
  void initState() {
    pages = [
      MultiProvider(
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
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoriteQuotes>(
            builder: (context) => FavoriteQuotes(),
          ),
          ChangeNotifierProvider<FavoriteImages>(
            builder: (context) => FavoriteImages(),
          ),
        ],
        child: Favorites(),
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
