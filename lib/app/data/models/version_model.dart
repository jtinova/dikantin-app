class Version {
  Datav? data;
  int? code;
  bool? status;

  Version({this.data, this.code, this.status});

  Version.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Datav?.fromJson(json['data']) : null;
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    if (this.data != null) {
      jsonData['data'] = this.data?.toJson();
    }
    jsonData['code'] = this.code;
    jsonData['status'] = this.status;
    return jsonData;
  }
}

class Datav {
  int? id;
  int? versionNumber;

  Datav({this.id, this.versionNumber});

  Datav.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    versionNumber = json['version_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['id'] = this.id;
    jsonData['version_number'] = this.versionNumber;
    return jsonData;
  }
}
