import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/models/quote_custom.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_random.dart';
import 'package:quoted_images/resources/file_handler_images.dart';
import 'package:quoted_images/widgets/custom_drawer.dart';

// TODO add stuff to drawer: favorites, settings, credits, about
// TODO read unsplash TOS
// TODO when finishing up, mention the quote source (https://github.com/lukePeavey/quotable) and unsplash
class Random extends StatefulWidget {
  @override
  _RandomState createState() => _RandomState();
}

class _RandomState extends State<Random> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Provider.of<RandomImages>(context, listen: false).init(context);
    Provider.of<RandomQuotes>(context, listen: false).init(context);
    super.initState();
  }

  Color getForegroundColor(Color backgroundColor) {
    Color foregroundColor = Colors.black38;

    if (backgroundColor.computeLuminance() < 0.5) {
      foregroundColor = Colors.white38;
    }

    return foregroundColor;
  }

  Color hexConvert(String color) {
    var hexColor = color.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "DF" + hexColor;
    }

    Color retColor = Color(int.parse(hexColor, radix: 16));
    return retColor.withOpacity(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<RandomImages>(
      builder: (context, imageModel, child) {
        Color backgroundColor = imageModel.images.isNotEmpty
            ? hexConvert(imageModel.images[imageModel.currentImgIndex].color)
            : Colors.white38;
        Color foregroundColor = getForegroundColor(backgroundColor);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'random',
              style: TextStyle(color: foregroundColor),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // overriding the drawer icon, so it can change colors
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(
                  Icons.menu,
                  color: foregroundColor,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: CustomDrawer(),
          body: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Divider(
                  height: 0,
                  color: foregroundColor,
                ),
                Expanded(
                  flex: 2,
                  child: Consumer<RandomQuotes>(
                    builder: (context, quoteModel, child) => QuoteSection(
                      model: quoteModel,
                      color: foregroundColor,
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: foregroundColor,
                ),
                Expanded(
                  flex: 6,
                  child: ImageSection(
                    model: imageModel,
                    color: foregroundColor,
                  ),
                )
              ],
            ),
          ),
//          floatingActionButton: FloatingActionButton(
//            onPressed: () {
//              ImageFileHandler fh = ImageFileHandler();
//              fh
//                  .getAllImages()
//                  .then((q) => q.forEach((image) => print(image.id)));
//            },
//          ),
        );
      },
    );
  }
}

class QuoteSection extends StatefulWidget {
  final Key key;
  final RandomQuotes model;
  final Color color;

  QuoteSection({this.key, @required this.model, @required this.color});

  @override
  _QuoteSectionState createState() => _QuoteSectionState();
}

class _QuoteSectionState extends State<QuoteSection> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.model.quotes.length,
      onPageChanged: (newIndex) {
        widget.model.changeIndex(context, newIndex);
      },
      itemBuilder: (context, index) {
        CustomQuote quote = widget.model.quotes[widget.model.currentQuoteIndex];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  quote.content,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: widget.color,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '- ${quote.author}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await widget.model.toggleFavorite(quote);
                    setState(() {});
//                  var permissionService = Provider.of<PermissionService>(context, listen: false);
//                  bool hasStoragePermission = await permissionService.hasStoragePermission();
//                  if (hasStoragePermission) {
////                    quoteToggleFavorite();
//                  } else {
//                    Provider.of<PermissionService>(context, listen: false)
//                        .requestStoragePermission();
//                  }
                  },
                  // onPressed: () => toggleFavorite(),
                  icon: Icon(
                    quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ImageSection extends StatefulWidget {
  final Key key;
  final RandomImages model;
  final Color color;

  ImageSection({this.key, @required this.model, @required this.color});

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.model.images.length,
      onPageChanged: (newIndex) {
        widget.model.changeIndex(context, newIndex);
      },
      itemBuilder: (context, index) {
        CustomImage image = widget.model.images[index];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  image.url,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
//              IconButton(
//                onPressed: null,
//                // onPressed: () => showModalBottomSheet(
//                // context: context,
//                // backgroundColor: _backgroundColor,
//                // builder: (context) {
//                //   return bottomSheetContent();
//                // }),
//                icon: Icon(
//                  Icons.info_outline,
//                  color: widget.color,
//                ),
//              ),
//              IconButton(
//                onPressed: null,
//                icon: Icon(
//                  Icons.save_alt,
//                  color: widget.color,
//                ),
//              ),
                IconButton(
                  onPressed: () async {
                    await widget.model.toggleFavorite(image);
                    setState(() {});
                  },
                  icon: Icon(
                    image.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
