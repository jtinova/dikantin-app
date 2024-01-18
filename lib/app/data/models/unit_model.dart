class Unit {
  List<Data>? data;
  bool? status;
  String? message;

  Unit({this.data, this.status, this.message});

  Unit.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
    data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
  
}

class Data {
  int? idGedung;
  String? namaGedung;
  String? lattitude;
  String? longtitude;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.idGedung,
      this.namaGedung,
      this.lattitude,
      this.longtitude,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    idGedung = json['id_gedung'];
    namaGedung = json['nama_gedung'];
    lattitude = json['lattitude'];
    longtitude = json['longtitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_gedung'] = idGedung;
    data['nama_gedung'] = namaGedung;
    data['lattitude'] = lattitude;
    data['longtitude'] = longtitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
