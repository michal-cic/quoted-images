import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/models/image_unsplash.dart';
import 'package:quoted_images/resources/unsplash_api.dart';


class RandomImages with ChangeNotifier {
  List<CustomImage> images = [];
  int currentImgIndex = 0;

  Future init(BuildContext context) async {
    await loadMore(30);
    precacheImage(NetworkImage(images[0].url), context);
    precacheImage(NetworkImage(images[1].url), context);
  }

  Future loadMore(int count) async {
    List<UnsplashImage> unsplashImages =
        await UnsplashApi.fetchRandomImages(count);

    for (var unsplashImg in unsplashImages) {
      bool isFavorite = true; // await checkFavorite(unsplashImg.id);
      images.add(CustomImage(unsplashImg.id, unsplashImg.urls.regular,
          isFavorite, hexConvert(unsplashImg.color)));
    }

    notifyListeners();
  }

  changeIndex(BuildContext context, int index) {
    if (index > currentImgIndex) {
      precacheImage(NetworkImage(images[index + 1].url), context);
    } else if (index < currentImgIndex && index > 0) {
      precacheImage(NetworkImage(images[index - 1].url), context);
    }

    if (index + 3 == images.length) {
      loadMore(30);
    }

    currentImgIndex = index;
    notifyListeners();
  }

  Future<bool> checkFavorite(String imageId) async {
    final favDir = await _favoriteDir;
    bool exists = await File('${favDir.path}/$imageId').exists();
    return exists;
  }

  Color hexConvert(String color) {
    var hexColor = color.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "DF" + hexColor;
    }

    Color retColor = Color(int.parse(hexColor, radix: 16));
    return retColor.withOpacity(1);
  }

  // void toggleFavorite() async {
  //   String imgId = _image['id'];
  //   bool isFavorite = await checkFavorite(imgId);

  //   if (!isFavorite) {
  //     saveFavorite(_image);
  //     _isFavorite = true;
  //   } else {
  //     deleteFavorite(imgId);
  //     _isFavorite = false;
  //   }

  //   setState(() {});
  // }

  Future<Directory> get _dir async {
    Directory dir = await getApplicationDocumentsDirectory();
    await createDirectories(dir.path);
    return dir;
  }

  Future createDirectories(String dirPath) async {
    Directory fav = await _favoriteDir;
    bool favExists = await Directory(fav.path).exists();
    String savedPath = dirPath + '/saved';
    bool savedExists = await Directory(savedPath).exists();

    if (!favExists) {
      Directory(fav.path).create();
    }

    if (!savedExists) {
      Directory(savedPath).create();
    }
  }

  Future<Directory> get _favoriteDir async {
    Directory appDocDir = await _dir;
    return Directory(appDocDir.path + '/favorites');
  }

  Future<File> saveFavorite(var imageData) async {
    final dir = await _favoriteDir;
    String imgId = imageData['id'];
    File file = File('${dir.path}/$imgId');

    // Write the file.
    return file.writeAsString(jsonEncode(imageData));
  }

  void deleteFavorite(String imageId) async {
    final dir = await _favoriteDir;
    File file = File('${dir.path}/$imageId');

    file.deleteSync();
  }
}
