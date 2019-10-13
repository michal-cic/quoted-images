class QuotableQuote {
  String id;
  String content;
  String author;

  QuotableQuote({this.id, this.content, this.author});

  QuotableQuote.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    content = json['content'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['author'] = this.author;
    return data;
  }
}