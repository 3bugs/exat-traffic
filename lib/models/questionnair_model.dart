class QuestionnaireModel {
  List<Data> data;
  String error;
  String statusCode;

  QuestionnaireModel({this.data, this.error, this.statusCode});

  QuestionnaireModel.fromJson(Map<String, dynamic> json) {
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
  String detail;
  int enable;
  int status;
  int mode;

  Data({this.id, this.name, this.detail, this.enable, this.status, this.mode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    detail = json['detail'];
    enable = json['enable'];
    status = json['status'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['enable'] = this.enable;
    data['status'] = this.status;
    data['mode'] = this.mode;
    return data;
  }
}
