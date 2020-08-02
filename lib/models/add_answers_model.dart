class AddAnswersModel {
  Data data;
  var error;
  var statusCode;

  AddAnswersModel({this.data, this.error, this.statusCode});

  AddAnswersModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int id;
  var questId;
  var score;
  String detail;
  var lat;
  var lng;
  var token;
  var updatedAt;
  var createdAt;

  Data(
      {this.id,
        this.questId,
        this.score,
        this.detail,
        this.lat,
        this.lng,
        this.token,
        this.updatedAt,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questId = json['quest_id'];
    score = json['score'];
    detail = json['detail'];
    lat = json['lat'];
    lng = json['lng'];
    token = json['token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quest_id'] = this.questId;
    data['score'] = this.score;
    data['detail'] = this.detail;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['token'] = this.token;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

