import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/models/image_custom.dart';
import 'package:quoted_images/models/quote_custom.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_random.dart';
import 'package:quoted_images/util/color.dart';

// TODO add stuff to drawer: favorites, settings, credits, about
// TODO read unsplash TOS
// TODO when finishing up, mention the quote source (https://github.com/lukePeavey/quotable) and unsplash
class Random extends StatefulWidget {
  @override
  _RandomState createState() => _RandomState();
}

class _RandomState extends State<Random> {
  @override
  void initState() {
    Provider.of<RandomImages>(context, listen: false).initRandom(context);
    Provider.of<RandomQuotes>(context, listen: false).init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RandomImages>(
      builder: (context, imageModel, child) {
        Color backgroundColor = imageModel.randomImages.isNotEmpty
            ? ColorUtility.hexConvert(
                imageModel.randomImages[imageModel.randomImgIndex].color)
            : Colors.white38;
        Color foregroundColor = ColorUtility.getNegativeColor(backgroundColor);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'random',
              style: TextStyle(color: foregroundColor),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: backgroundColor,
                  height: 1,
                ),
                Divider(
                  height: 0,
                  color: foregroundColor,
                ),
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    color: backgroundColor,
                    child: Consumer<RandomQuotes>(
                      builder: (context, quoteModel, child) => QuoteSection(
                        model: quoteModel,
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: foregroundColor,
                ),
                Expanded(
                  flex: 6,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    color: backgroundColor,
                    child: ImageSection(
                      model: imageModel,
                      color: foregroundColor,
                    ),
                  ),
                )
              ],
            ),
          ),
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
    if (widget.model.quotes.length == 0) {
      return Center(
        child: Text(
          'getting quotes...',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: widget.color,
          ),
        ),
      );
    } else {
      return PageView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.model.quotes.length,
        onPageChanged: (newIndex) {
          widget.model.changeIndex(context, newIndex);
        },
        itemBuilder: (context, index) {
          CustomQuote quote =
              widget.model.quotes[widget.model.currentQuoteIndex];
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 8.0),
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
            ],
          );
        },
      );
    }
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
    if (widget.model.randomImages.length == 0) {
      return Center(
        child: Text(
          'getting images...',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: widget.color,
          ),
        ),
      );
    } else {
      return PageView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.model.randomImages.length,
        onPageChanged: (newIndex) {
          widget.model.changeRandomIndex(context, newIndex);
        },
        itemBuilder: (context, index) {
          CustomImage image = widget.model.randomImages[index];

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
            ],
          );
        },
      );
    }
  }
}
