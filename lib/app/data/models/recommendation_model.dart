class Recommendation {
  List<DataRekomendasi>? data;
  int? code;
  bool? status;

  Recommendation({this.data, this.code, this.status});

  Recommendation.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataRekomendasi>[];
      json['data'].forEach((v) {
        data?.add(DataRekomendasi.fromJson(v));
      });
    }
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}

class DataRekomendasi {
  int? idMenu;
  String? namaMenu;
  int? hargaMenu;
  String? totalQtyPesanan;
  String? namaKantin;
  String? kategoriMenu;
  String? foto;

  DataRekomendasi(
      {this.idMenu,
      this.namaMenu,
      this.hargaMenu,
      this.totalQtyPesanan,
      this.namaKantin,
      this.kategoriMenu,
      this.foto});

  DataRekomendasi.fromJson(Map<String, dynamic> json) {
    idMenu = json['id_menu'];
    namaMenu = json['nama_menu'];
    hargaMenu = json['harga_menu'];
    totalQtyPesanan = json['total_qty_pesanan'];
    namaKantin = json['nama_kantin'];
    kategoriMenu = json['kategori_menu'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_menu'] = idMenu;
    data['nama_menu'] = namaMenu;
    data['harga_menu'] = hargaMenu;
    data['total_qty_pesanan'] = totalQtyPesanan;
    data['nama_kantin'] = namaKantin;
    data['kategori_menu'] = kategoriMenu;
    data['foto'] = foto;
    return data;
  }
}
