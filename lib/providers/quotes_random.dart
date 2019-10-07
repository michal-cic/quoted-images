import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/quote.dart';
import 'package:quoted_images/resources/quote_api.dart';

class RandomQuotes with ChangeNotifier {
  List<Quote> quotes = [];
  int currentQuoteIndex = 0;

  Future init(BuildContext context) async {
    await loadMore(5);
  }

  Future loadMore(int count) async {
    quotes = await QuoteApi.loadQuotes(count);
    notifyListeners();
  }

  changeIndex(BuildContext context, int index) {
    currentQuoteIndex = index;
    notifyListeners();
  }

  // Future<bool> checkFavorite(String imageId) async {
  //   final favDir = await _favoriteDir;
  //   bool exists = await File('${favDir.path}/$imageId').exists();
  //   return exists;
  // }
}
