class NewsModel {
  String sId;
  int id;
  String title;
  String content;
  String date;
  int iV;

  NewsModel({this.sId, this.id, this.title, this.content, this.date, this.iV});

  NewsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['__v'] = this.iV;
    return data;
  }
}
