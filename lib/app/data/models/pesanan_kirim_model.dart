class PesananKirim {
  List<DataPesananKirim>? data;
  int? code;
  bool? status;

  PesananKirim({this.data, this.code, this.status});

  PesananKirim.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataPesananKirim>[];
      json['data'].forEach((v) {
        data?.add(DataPesananKirim.fromJson(v));
      });
    }
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['status'] = this.status;

    return data;
  }
}

class DataPesananKirim {
  String? status;
  Transaksi? transaksi;

  DataPesananKirim({this.status, this.transaksi});

  DataPesananKirim.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    transaksi = json['transaksi'] != null
        ? Transaksi?.fromJson(json['transaksi'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (transaksi != null) {
      data['transaksi'] = transaksi?.toJson();
    }
    return data;
  }
}

class Transaksi {
  String? kodeTr;
  String? statusKonfirm;
  String? statusPesanan;
  String? tanggal;
  String? idCustomer;
  String? idKurir;
  dynamic idKasir;
  int? totalBayar;
  int? totalHarga;
  int? kembalian;
  String? statusPengiriman;
  dynamic buktiPengiriman;
  int? noMeja;
  String? modelPembayaran;
  String? expiredAt;
  String? createdAt;
  String? updatedAt;
  String? nama;
  String? noTelepon;
  int? emailVerified;
  dynamic kodeVerified;
  String? token;
  dynamic tokenFcm;
  String? alamat;
  String? longitude;
  String? latitude;
  String? email;
  String? password;
  dynamic foto;
  dynamic googleId;
  String? keterangan;
  List<DetailTransaksi>? detailTransaksi;

  Transaksi(
      {this.kodeTr,
      this.statusKonfirm,
      this.statusPesanan,
      this.tanggal,
      this.idCustomer,
      this.idKurir,
      this.idKasir,
      this.totalBayar,
      this.totalHarga,
      this.kembalian,
      this.statusPengiriman,
      this.buktiPengiriman,
      this.noMeja,
      this.modelPembayaran,
      this.expiredAt,
      this.createdAt,
      this.updatedAt,
      this.nama,
      this.noTelepon,
      this.emailVerified,
      this.kodeVerified,
      this.token,
      this.tokenFcm,
      this.alamat,
      this.longitude,
      this.latitude,
      this.email,
      this.password,
      this.foto,
      this.googleId,
      this.keterangan,
      this.detailTransaksi});

  Transaksi.fromJson(Map<String, dynamic> json) {
    kodeTr = json['kode_tr'];
    statusKonfirm = json['status_konfirm'];
    statusPesanan = json['status_pesanan'];
    tanggal = json['tanggal'];
    idCustomer = json['id_customer'];
    idKurir = json['id_kurir'];
    idKasir = json['id_kasir'];
    totalBayar = json['total_bayar'];
    totalHarga = json['total_harga'];
    kembalian = json['kembalian'];
    statusPengiriman = json['status_pengiriman'];
    buktiPengiriman = json['bukti_pengiriman'];
    noMeja = json['no_meja'];
    modelPembayaran = json['model_pembayaran'];
    expiredAt = json['expired_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nama = json['nama'];
    noTelepon = json['no_telepon'];
    emailVerified = json['email_verified'];
    kodeVerified = json['kode_verified'];
    token = json['token'];
    tokenFcm = json['token_fcm'];
    alamat = json['alamat'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    email = json['email'];
    password = json['password'];
    foto = json['foto'];
    googleId = json['google_id'];
    keterangan = json['keterangan'];
    if (json['detail_transaksi'] != null) {
      detailTransaksi = <DetailTransaksi>[];
      json['detail_transaksi'].forEach((v) {
        detailTransaksi?.add(DetailTransaksi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kode_tr'] = kodeTr;
    data['status_konfirm'] = statusKonfirm;
    data['status_pesanan'] = statusPesanan;
    data['tanggal'] = tanggal;
    data['id_customer'] = idCustomer;
    data['id_kurir'] = idKurir;
    data['id_kasir'] = idKasir;
    data['total_bayar'] = totalBayar;
    data['total_harga'] = totalHarga;
    data['kembalian'] = kembalian;
    data['status_pengiriman'] = statusPengiriman;
    data['bukti_pengiriman'] = buktiPengiriman;
    data['no_meja'] = noMeja;
    data['model_pembayaran'] = modelPembayaran;
    data['expired_at'] = expiredAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['nama'] = nama;
    data['no_telepon'] = noTelepon;
    data['email_verified'] = emailVerified;
    data['kode_verified'] = kodeVerified;
    data['token'] = token;
    data['token_fcm'] = tokenFcm;
    data['alamat'] = alamat;
    data['email'] = email;
    data['password'] = password;
    data['foto'] = foto;
    data['google_id'] = googleId;
    if (detailTransaksi != null) {
      data['detail_transaksi'] =
          detailTransaksi?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailTransaksi {
  String? kodeTr;
  int? qTY;
  int? subtotalBayar;
  int? kodeMenu;
  String? statusKonfirm;
  String? createdAt;
  String? updatedAt;
  Menu? menu;

  DetailTransaksi(
      {this.kodeTr,
      this.qTY,
      this.subtotalBayar,
      this.kodeMenu,
      this.statusKonfirm,
      this.createdAt,
      this.updatedAt,
      this.menu});

  DetailTransaksi.fromJson(Map<String, dynamic> json) {
    kodeTr = json['kode_tr'];
    qTY = json['QTY'];
    subtotalBayar = json['subtotal_bayar'];
    kodeMenu = json['kode_menu'];
    statusKonfirm = json['status_konfirm'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menu = json['menu'] != null ? Menu?.fromJson(json['menu']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kode_tr'] = kodeTr;
    data['QTY'] = qTY;
    data['subtotal_bayar'] = subtotalBayar;
    data['kode_menu'] = kodeMenu;
    data['status_konfirm'] = statusKonfirm;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (menu != null) {
      data['menu'] = menu?.toJson();
    }
    return data;
  }
}

class Menu {
  int? idMenu;
  String? nama;
  int? harga;
  String? foto;
  String? statusStok;
  String? kategori;
  int? idKantin;
  dynamic diskon;
  String? createdAt;
  String? updatedAt;

  Menu(
      {this.idMenu,
      this.nama,
      this.harga,
      this.foto,
      this.statusStok,
      this.kategori,
      this.idKantin,
      this.diskon,
      this.createdAt,
      this.updatedAt});

  Menu.fromJson(Map<String, dynamic> json) {
    idMenu = json['id_menu'];
    nama = json['nama'];
    harga = json['harga'];
    foto = json['foto'];
    statusStok = json['status_stok'];
    kategori = json['kategori'];
    idKantin = json['id_kantin'];
    diskon = json['diskon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_menu'] = idMenu;
    data['nama'] = nama;
    data['harga'] = harga;
    data['foto'] = foto;
    data['status_stok'] = statusStok;
    data['kategori'] = kategori;
    data['id_kantin'] = idKantin;
    data['diskon'] = diskon;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
