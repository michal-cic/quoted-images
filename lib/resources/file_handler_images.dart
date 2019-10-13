import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quoted_images/models/image_custom.dart';

class ImageFileHandler {
  Future<bool> checkFavorite(String imageId) async {
    final favDir = await _favoriteDir;
    bool exists = await File('${favDir.path}/$imageId').exists();
    return exists;
  }

  Future<Directory> get _dir async {
    Directory dir = await getApplicationDocumentsDirectory();
    await createDirectories(dir.path);
    return dir;
  }

  Future createDirectories(String dirPath) async {
    String quotesPath = dirPath + '/images';
    bool quotesDirExists = await Directory(quotesPath).exists();
    if (!quotesDirExists) {
      await Directory(quotesPath).create();
    }

    String favPath = dirPath + '/images/favorite';
    bool favExists = await Directory(favPath).exists();
//    String savedPath = dirPath + '/images/saved';
//    bool savedExists = await Directory(savedPath).exists();

    if (!favExists) {
      Directory(favPath).create();
    }

//    if (!savedExists) {
//      Directory(savedPath).create();
//    }
  }

  Future<Directory> get _favoriteDir async {
    Directory appDocDir = await _dir;
    return Directory(appDocDir.path + '/images/favorite');
  }

  Future<bool> saveFavorite(CustomImage image) async {
    final dir = await _favoriteDir;
    File file = File('${dir.path}/${image.id}');

    // Write the file.
    await file.writeAsString(jsonEncode(image.toJson()));
    return await file.exists();
  }

  Future<bool> deleteFavorite(String imageId) async {
    final dir = await _favoriteDir;
    File file = File('${dir.path}/$imageId');

    file.deleteSync();

    return await file.exists();
  }

  Future<List<CustomImage>> getAllImages() async {
    Directory fav = await _favoriteDir;
    List<File> files = fav.listSync().whereType<File>().toList();
    List<CustomImage> images = [];

    files.forEach((file) {
      // reads the image file and transforms it to CustomImage type, adds it to the list
      images.add(CustomImage.fromJson(jsonDecode(file.readAsStringSync())));
    });

    return images;
  }
}
