import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/models/image_unsplash.dart';
import 'package:quoted_images/resources/file_handler_images.dart';
import 'package:quoted_images/resources/unsplash_api.dart';


class RandomImages with ChangeNotifier {
  List<CustomImage> images = [];
  int currentImgIndex = 0;
  ImageFileHandler _fileHandler = ImageFileHandler();

  Future init(BuildContext context) async {
    await loadMore(30);
    precacheImage(NetworkImage(images[0].url), context);
    precacheImage(NetworkImage(images[1].url), context);
  }

  Future loadMore(int count) async {
    List<UnsplashImage> unsplashImages =
        await UnsplashApi.fetchRandomImages(count);

    for (var unsplashImg in unsplashImages) {
      bool isFavorite = await _fileHandler.checkFavorite(unsplashImg.id);
      images.add(CustomImage(unsplashImg.id, unsplashImg.urls.regular,
          isFavorite, unsplashImg.color));
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
