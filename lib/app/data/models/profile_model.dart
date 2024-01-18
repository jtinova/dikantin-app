class Profile {
  Data? data;
  int? code;
  bool? status;

  Profile({this.data, this.code, this.status});

  Profile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data?.fromJson(json['data']) : null;
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? idCustomer;
  String? nama;
  String? noTelepon;
  int? emailVerified;
  dynamic kodeVerified;
  String? token;
  String? tokenFcm;
  String? alamat;
  String? email;
  dynamic foto;
  dynamic googleId;
  String? ket;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.idCustomer,
      this.nama,
      this.noTelepon,
      this.emailVerified,
      this.kodeVerified,
      this.token,
      this.tokenFcm,
      this.alamat,
      this.email,
      this.foto,
      this.latitude,
      this.longitude,
      this.ket,
      this.googleId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    idCustomer = json['id_customer'];
    nama = json['nama'];
    noTelepon = json['no_telepon'];
    emailVerified = json['email_verified'];
    kodeVerified = json['kode_verified'];
    token = json['token'];
    tokenFcm = json['token_fcm'];
    alamat = json['alamat'];
    email = json['email'];
    foto = json['foto'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ket = json['keterangan'];
    googleId = json['google_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_customer'] = idCustomer;
    data['nama'] = nama;
    data['no_telepon'] = noTelepon;
    data['email_verified'] = emailVerified;
    data['kode_verified'] = kodeVerified;
    data['token'] = token;
    data['token_fcm'] = tokenFcm;
    data['alamat'] = alamat;
    data['email'] = email;
    data['foto'] = foto;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['keterangan'] = ket;
    data['google_id'] = googleId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
