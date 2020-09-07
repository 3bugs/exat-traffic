class IncidentDetailModel {
  Data data;
  dynamic dataMappingLangs;
  String error;
  String statusCode;

  IncidentDetailModel(
      {this.data, this.dataMappingLangs, this.error, this.statusCode});

  IncidentDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    dataMappingLangs = json['data_mapping_langs'];
    error = json['error'];
    statusCode = json['status_code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['data_mapping_langs'] = this.dataMappingLangs;
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int id;
  String title;
  String detail;
  String timeopen;
  String timeclose;
  int statusMes;
  int statusType;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;
  String cover;
  double lat;
  double lng;

  Data(
      {this.id,
        this.title,
        this.detail,
        this.timeopen,
        this.timeclose,
        this.statusMes,
        this.statusType,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.cover,
        this.lat,
        this.lng});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    timeopen = json['timeopen'];
    timeclose = json['timeclose'];
    statusMes = json['status_mes'];
    statusType = json['status_type'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cover = json['cover'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['timeopen'] = this.timeopen;
    data['timeclose'] = this.timeclose;
    data['status_mes'] = this.statusMes;
    data['status_type'] = this.statusType;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cover'] = this.cover;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
