class Search {
  List<Datasearch>? data;
  int? code;
  bool? status;

  Search({this.data, this.code, this.status});

  Search.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datasearch>[];
      json['data'].forEach((v) {
        data?.add(Datasearch.fromJson(v));
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

class Datasearch {
  int? idMenu;
  String? nama;
  int? harga;
  String? foto;
  String? statusStok;
  String? kategori;
  int? idKantin;
  String? namaKantin;
  dynamic diskon;
  String? penjualanHariIni;
  String? jumlahSubtotal;
  String? createdAt;
  String? updatedAt;

  Datasearch(
      {this.idMenu,
      this.nama,
      this.harga,
      this.foto,
      this.statusStok,
      this.kategori,
      this.idKantin,
      this.namaKantin,
      this.diskon,
      this.penjualanHariIni,
      this.jumlahSubtotal,
      this.createdAt,
      this.updatedAt});

  Datasearch.fromJson(Map<String, dynamic> json) {
    idMenu = json['id_menu'];
    nama = json['nama'];
    harga = json['harga'];
    foto = json['foto'];
    statusStok = json['status_stok'];
    kategori = json['kategori'];
    idKantin = json['id_kantin'];
    namaKantin = json['nama_kantin'];
    diskon = json['diskon'];
    penjualanHariIni = json['penjualan_hari_ini'];
    jumlahSubtotal = json['jumlah_subtotal'];
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
    data['nama_kantin'] = namaKantin;
    data['diskon'] = diskon;
    data['penjualan_hari_ini'] = penjualanHariIni;
    data['jumlah_subtotal'] = jumlahSubtotal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
