import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/quote_custom.dart';
import 'package:quoted_images/resources/file_handler_quotes.dart';

class FavoriteQuotes with ChangeNotifier{
  List<CustomQuote> quotes = [];
  int currentQuoteIndex = 0;
  QuoteFileHandler _fileHandler = QuoteFileHandler();

  Future init(BuildContext context) async {
    await loadMore(0);
  }

  Future loadMore(int count) async {
    quotes = await _fileHandler.getAllQuotes();

    notifyListeners();
  }

  changeIndex(BuildContext context, int index) {
    if (index > quotes.length - 5) {
      loadMore(10);
    }
    currentQuoteIndex = index;
    notifyListeners();
  }

  Future toggleFavorite(CustomQuote quote) async{
    if(quote.isFavorite) {
      await _fileHandler.deleteFavorite(quote.id);
    } else {
      quote.isFavorite = true;
      await _fileHandler.saveFavorite(quote);
    }

    quote.isFavorite = await _fileHandler.checkFavorite(quote.id);
  }
}