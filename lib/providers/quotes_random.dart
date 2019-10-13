import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/quote_custom.dart';
import 'package:quoted_images/models/quote_quotable.dart';
import 'package:quoted_images/resources/file_handler_quotes.dart';
import 'package:quoted_images/resources/quotable_api.dart';

class RandomQuotes with ChangeNotifier {
  List<CustomQuote> quotes = [];
  int currentQuoteIndex = 0;
  QuoteFileHandler fileHandler = QuoteFileHandler();

  Future init(BuildContext context) async {
    await loadMore(5);
  }

  Future loadMore(int count) async {
    List<QuotableQuote> futureQuotes = await QuotableApi.loadQuotes(count);

    for (QuotableQuote quote in futureQuotes) {
      bool isFavorite = await fileHandler.checkFavorite(quote.id);
      quotes.add(CustomQuote(quote.id, quote.content, quote.author, isFavorite));
    }

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
      await fileHandler.deleteFavorite(quote.id);
    } else {
      quote.isFavorite = true;
      await fileHandler.saveFavorite(quote);
    }

    quote.isFavorite = await fileHandler.checkFavorite(quote.id);
  }
}
