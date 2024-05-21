class Pesanan {
  List<DataPesanan>? data;
  int? code;
  bool? status;

  Pesanan({this.data, this.code, this.status});

  Pesanan.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataPesanan>[];
      json['data'].forEach((v) {
        data?.add(DataPesanan.fromJson(v));
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
    data['code'] = code;
    data['status'] = status;

    return data;
  }
}

class DataPesanan {
  String? status;
  Transaksi? transaksi;

  DataPesanan({this.status, this.transaksi});

  DataPesanan.fromJson(Map<String, dynamic> json) {
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
  int? totalBayar;
  int? totalHarga;
  int? totalKurir;
  int? kembalian;
  String? statusPengiriman;
  String? buktiPengiriman;
  String? modelPembayaran;
  String? createdAt;
  String? updatedAt;
  List<DetailTransaksi>? detailTransaksi;

  Transaksi(
      {this.kodeTr,
      this.statusKonfirm,
      this.statusPesanan,
      this.tanggal,
      this.idCustomer,
      this.idKurir,
      this.totalBayar,
      this.totalHarga,
      this.totalKurir,
      this.kembalian,
      this.statusPengiriman,
      this.buktiPengiriman,
      this.modelPembayaran,
      this.createdAt,
      this.updatedAt,
      this.detailTransaksi});

  Transaksi.fromJson(Map<String, dynamic> json) {
    kodeTr = json['kode_tr'];
    statusKonfirm = json['status_konfirm'];
    statusPesanan = json['status_pesanan'];
    tanggal = json['tanggal'];
    idCustomer = json['id_customer'];
    idKurir = json['id_kurir'];
    totalBayar = json['total_bayar'];
    totalHarga = json['total_harga'];
    totalKurir = json['total_biaya_kurir'];
    kembalian = json['kembalian'];
    statusPengiriman = json['status_pengiriman'];
    buktiPengiriman = json['bukti_pengiriman'];
    modelPembayaran = json['model_pembayaran'];
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
    data['total_bayar'] = totalBayar;
    data['total_harga'] = totalHarga;
    data['total_biaya _kurir'] = totalKurir;
    data['kembalian'] = kembalian;
    data['status_pengiriman'] = statusPengiriman;
    data['bukti_pengiriman'] = buktiPengiriman;
    data['model_pembayaran'] = modelPembayaran;
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
  int? kodeMenu;
  dynamic statusKonfirm;
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
  int? diskon;
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
