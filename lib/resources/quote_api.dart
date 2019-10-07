import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quoted_images/models/quote.dart';

class QuoteApi {
  static Future<List<Quote>> loadQuotes(int count) async {
    List<Quote> quotes = [];

    for (var i = 0; i < count; i++) {
      var rawQuote = await http.get('https://api.quotable.io/random');
      quotes.add(Quote.fromJson(jsonDecode(rawQuote.body)));
    }

    return quotes;
  }
}
