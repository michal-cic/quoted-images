import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quoted_images/models/quote_custom.dart';

class QuoteFileHandler {
  Future<bool> checkFavorite(String quoteId) async {
    final favDir = await _favoriteDir;
    bool exists = await File('${favDir.path}/$quoteId').exists();
    return exists;
  }

  Future<Directory> get _dir async {
    Directory dir = await getApplicationDocumentsDirectory();
    await createDirectories(dir.path);
    return dir;
  }

  Future createDirectories(String dirPath) async {
    String quotesPath = dirPath + '/quotes';
    bool quotesDirExists = await Directory(quotesPath).exists();
    if (!quotesDirExists) {
      await Directory(quotesPath).create();
    }

    String favPath = dirPath + '/quotes/favorite';
    bool favExists = await Directory(favPath).exists();
    String savedPath = dirPath + '/quotes/saved';
    bool savedExists = await Directory(savedPath).exists();

    if (!favExists) {
      Directory(favPath).create();
    }

    if (!savedExists) {
      Directory(savedPath).create();
    }
  }

  Future<Directory> get _favoriteDir async {
    Directory appDocDir = await _dir;
    return Directory(appDocDir.path + '/quotes/favorite');
  }

  Future<bool> saveFavorite(CustomQuote quote) async {
    final dir = await _favoriteDir;
    File file = File('${dir.path}/${quote.id}');

    // Write the file.
    await file.writeAsString(jsonEncode(quote.toJson()));
    return await file.exists();
  }

  Future<bool> deleteFavorite(String quoteId) async {
    final dir = await _favoriteDir;
    File file = File('${dir.path}/$quoteId');

    file.deleteSync();

    return await file.exists();
  }

  Future<CustomQuote> getQuote(String quoteId) async {
    Directory fav = await _favoriteDir;
    File file = File(fav.path + '/$quoteId');

    if (file.existsSync()) {
      return CustomQuote.fromJson(jsonDecode(file.readAsStringSync()));
    } else {
      return null;
    }
  }

  Future<List<CustomQuote>> getAllQuotes() async {
    Directory fav = await _favoriteDir;
    List<File> files = fav.listSync().whereType<File>().toList();
    List<CustomQuote> quotes = [];

    files.forEach((file) {
      // reads the quote file and transforms it to CustomQuote type, adds it to the list
      quotes.add(CustomQuote.fromJson(jsonDecode(file.readAsStringSync())));
    });

    return quotes;
  }
}