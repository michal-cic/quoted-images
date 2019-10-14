import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/quote_custom.dart';
import 'package:quoted_images/models/quote_quotable.dart';
import 'package:quoted_images/resources/quotable_api.dart';

class RandomQuotes with ChangeNotifier {
  List<CustomQuote> quotes = [];
  int currentQuoteIndex = 0;

  Future init(BuildContext context) async {
    await loadMore(5);
  }

  Future loadMore(int count) async {
    List<QuotableQuote> futureQuotes = await QuotableApi.loadQuotes(count);

    for (QuotableQuote quote in futureQuotes) {
      quotes.add(CustomQuote(quote.id, quote.content, quote.author));
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
}
