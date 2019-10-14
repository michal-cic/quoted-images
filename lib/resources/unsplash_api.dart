import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quoted_images/models/image_unsplash.dart';
import 'package:quoted_images/util/keys.dart';

class UnsplashApi {
  // replace with your unsplash api key (you can get it here: https://unsplash.com/developers)
  static String accessKey = Keys.unsplashApiKey;

  static Future<List<UnsplashImage>> fetchRandomImages(int count) async {
    var response = await http.get(
      'https://api.unsplash.com/photos/random?count=$count',
      headers: {HttpHeaders.authorizationHeader: 'Client-ID $accessKey'},
    );

    List<UnsplashImage> unsplashImages = [];
    var jsonImages = jsonDecode(response.body);

    for (var jsonImg in jsonImages) {
      unsplashImages.add(UnsplashImage.fromJson(jsonImg));
    }

    return unsplashImages;
  }
}
