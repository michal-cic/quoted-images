import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/resources/file_handler_images.dart';

class FavoriteImages with ChangeNotifier{
  List<CustomImage> images = [];
  int currentImageIndex = 0;
  ImageFileHandler _fileHandler = ImageFileHandler();

  Future init(BuildContext context) async {
    await loadMore(0);
  }

  Future loadMore(int count) async {
    images = await _fileHandler.getAllImages();

    notifyListeners();
  }

  changeIndex(BuildContext context, int index) {
    if (index > images.length - 5) {
      loadMore(10);
    }
    currentImageIndex = index;
    notifyListeners();
  }

  Future toggleFavorite(CustomImage image) async{
    if(image.isFavorite) {
      await _fileHandler.deleteFavorite(image.id);
    } else {
      image.isFavorite = true;
      await _fileHandler.saveFavorite(image);
    }

    image.isFavorite = await _fileHandler.checkFavorite(image.id);
  }
}