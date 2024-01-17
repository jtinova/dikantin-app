class Belumbayar {
  List<DataBelumbayar>? data;
  int? code;
  bool? status;

  Belumbayar({this.data, this.code, this.status});

  Belumbayar.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataBelumbayar>[];
      json['data'].forEach((v) {
        data?.add(DataBelumbayar.fromJson(v));
      });
    }
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}

class DataBelumbayar {
  String? kodeTr;
  dynamic statusKonfirm;
  dynamic statusPesanan;
  String? tanggal;
  String? idCustomer;
  dynamic idKurir;
  dynamic idKasir;
  int? totalBayar;
  int? totalHarga;
  int? kembalian;
  dynamic statusPengiriman;
  dynamic buktiPengiriman;
  dynamic noMeja;
  String? modelPembayaran;
  String? expiredAt;
  dynamic totalBiayaKurir;
  String? createdAt;
  String? updatedAt;
  List<DetailTransaksi>? detailTransaksi;

  DataBelumbayar(
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
      this.totalBiayaKurir,
      this.createdAt,
      this.updatedAt,
      this.detailTransaksi});

  DataBelumbayar.fromJson(Map<String, dynamic> json) {
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
    totalBiayaKurir = json['total_biaya_kurir'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['total_biaya_kurir'] = totalBiayaKurir;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  int? subtotalHargapokok;
  int? kodeMenu;
  dynamic catatan;
  String? statusKonfirm;
  String? createdAt;
  String? updatedAt;
  Menu? menu;

  DetailTransaksi(
      {this.kodeTr,
      this.qTY,
      this.subtotalBayar,
      this.subtotalHargapokok,
      this.kodeMenu,
      this.catatan,
      this.statusKonfirm,
      this.createdAt,
      this.updatedAt,
      this.menu});

  DetailTransaksi.fromJson(Map<String, dynamic> json) {
    kodeTr = json['kode_tr'];
    qTY = json['QTY'];
    subtotalBayar = json['subtotal_bayar'];
    subtotalHargapokok = json['subtotal_hargapokok'];
    kodeMenu = json['kode_menu'];
    catatan = json['catatan'];
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
    data['subtotal_hargapokok'] = subtotalHargapokok;
    data['kode_menu'] = kodeMenu;
    data['catatan'] = catatan;
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
  int? hargaPokok;
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
      this.hargaPokok,
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
    hargaPokok = json['harga_pokok'];
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
    data['harga_pokok'] = hargaPokok;
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
