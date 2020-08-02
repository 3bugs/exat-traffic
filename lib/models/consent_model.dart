class ConsentModel {
  List<Data> data;
  String error;
  String statusCode;

  ConsentModel({this.data, this.error, this.statusCode});

  ConsentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int id;
  String name;
  String cover;
  String title;
  String excerpt;
  String content;
  Null bgColor;
  String status;
  int parent;
  int sort;
  String type;

  Data(
      {this.id,
        this.name,
        this.cover,
        this.title,
        this.excerpt,
        this.content,
        this.bgColor,
        this.status,
        this.parent,
        this.sort,
        this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    title = json['title'];
    excerpt = json['excerpt'];
    content = json['content'];
    bgColor = json['bg_color'];
    status = json['status'];
    parent = json['parent'];
    sort = json['sort'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['title'] = this.title;
    data['excerpt'] = this.excerpt;
    data['content'] = this.content;
    data['bg_color'] = this.bgColor;
    data['status'] = this.status;
    data['parent'] = this.parent;
    data['sort'] = this.sort;
    data['type'] = this.type;
    return data;
  }
}
