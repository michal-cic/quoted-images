import 'dart:ui';

class CustomImage {
  String _id;
  String _url;
  bool _isFavorite;
  Color _color;

  CustomImage(this._id, this._url, this._isFavorite, this._color);

  String get id => _id;
  String get url => _url;
  bool get isFavorite => _isFavorite;
  Color get color => _color;
}