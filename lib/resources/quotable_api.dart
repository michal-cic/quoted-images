import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quoted_images/models/quote_quotable.dart';

class QuotableApi {
  static Future<List<QuotableQuote>> loadQuotes(int count) async {
    List<QuotableQuote> quotes = [];

    for (var i = 0; i < count; i++) {
      var rawQuote = await http.get('https://api.quotable.io/random');
      quotes.add(QuotableQuote.fromJson(jsonDecode(rawQuote.body)));
    }

    return quotes;
  }
}
