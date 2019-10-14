class CustomImage {
  String _id;
  String _url;
  String _color;

  CustomImage(this._id, this._url, this._color);

  CustomImage.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _url = json['url'];
    _color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['color'] = this.color;
    return data;
  }

  String get id => _id;
  String get url => _url;
  String get color => _color;
}