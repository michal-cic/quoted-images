import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {  
  List<Map> _imgList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getFavoriteImages(),
        builder: (context, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, index) {
                return Image(image: NetworkImage(snap.data[index]['urls']['regular']));
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getFavoriteImages(),
      ),
    );
  }

  Future<Directory> get _dir async {
    Directory dir = await getApplicationDocumentsDirectory();
    createDirectories(dir.path);
    return dir;
  }

  void createDirectories(String dirPath) async {
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

  Future<String> readFavorite(var imageId) async {
    try {
      Directory dir = await _favoriteDir;
      final file = File('${dir.path}/imageId');

      // Read the file.
      String contents = await file.readAsString();
      print(contents);

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return 'data reading error';
    }
  }

  Future<List<Map>> getFavoriteImages() async {
    List<Map> imgList = [];
    final favDir = await _favoriteDir;
    var favorites = favDir.listSync().whereType<File>();

    for (var img in favorites) {
      imgList.add(jsonDecode(img.readAsStringSync()));
    }

    _imgList = imgList;
    return imgList;
  }
}