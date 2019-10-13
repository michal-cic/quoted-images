class CustomQuote {
  String id;
  String content;
  String author;
  bool isFavorite;

  CustomQuote(this.id, this.content, this.author, this.isFavorite);

  CustomQuote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    author = json['author'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['author'] = this.author;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}