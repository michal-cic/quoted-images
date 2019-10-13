class CustomImage {
  String _id;
  String _url;
  bool isFavorite;
  String _color;

  CustomImage(this._id, this._url, this.isFavorite, this._color);

  CustomImage.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _url = json['url'];
    _color = json['color'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['color'] = this.color;
    data['isFavorite'] = this.isFavorite;
    return data;
  }

  String get id => _id;
  String get url => _url;
  String get color => _color;
}