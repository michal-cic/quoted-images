import 'package:flutter/widgets.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/models/image_unsplash.dart';
import 'package:quoted_images/resources/unsplash_api.dart';

class CustomImageProvider with ChangeNotifier {
  List<CustomImage> randomImages = [];
  int randomImgIndex = 0;

  Future initRandom(BuildContext context) async {
    await loadRandom(30);
    precacheImage(NetworkImage(randomImages[0].url), context);
    precacheImage(NetworkImage(randomImages[1].url), context);
  }

  Future loadRandom(int count) async {
    List<UnsplashImage> unsplashImages =
        await UnsplashApi.fetchRandomImages(count);

    for (var unsplashImg in unsplashImages) {
      randomImages.add(CustomImage(
          unsplashImg.id, unsplashImg.urls.regular, unsplashImg.color));
    }

    notifyListeners();
  }

  changeRandomIndex(BuildContext context, int index) {
    if (index > randomImgIndex) {
      precacheImage(NetworkImage(randomImages[index + 1].url), context);
    } else if (index < randomImgIndex && index > 0) {
      precacheImage(NetworkImage(randomImages[index - 1].url), context);
    }

    if (index + 3 == randomImages.length) {
      loadRandom(30);
    }

    randomImgIndex = index;
    notifyListeners();
  }
}
