import 'dart:convert';
import 'package:dikantin/app/data/models/cancel_model.dart';
import 'package:dikantin/app/data/models/pendapatanKurir_model.dart';
import 'package:dikantin/app/data/models/pesanan_model.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/belumbayar_model.dart';
import '../models/pesanan_kirim_model.dart';
import 'services.dart';

class PesananProvider extends GetxController {
  Future<Pesanan> proses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.pesananProses),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Pesanan> dikirim() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.pesananDikirim),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Pesanan> diterima() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.pesananDiterima),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Pesanan> belumbayar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.getBelumbayar),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<void> batalkanPesanan(String kodeTr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idCustomer = prefs.getString('id_customer');
    print('Ini:$idCustomer');
    final Map<String, String> postData = {
      "kode": "0",
      "customer": idCustomer.toString(), // sesuaikan dengan kantin yang login
      "kode_tr": kodeTr,
    };

    final response = await http.post(
      Uri.parse(Api.konfirmasi),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      print('Pesanan berhasil dibatalkan');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal membatalkan pesanan. Status code: ${response.statusCode}');
      throw Exception('Gagal membatalkan pesanan');
    }
  }

  Future<void> acceptPesanan(String kodeTr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idKurir = prefs.getString('tokenKurir');
    print('Ini:$idKurir');
    final Map<String, String> postData = {
      "kode": "3",
      "kurir": idKurir.toString(), // sesuaikan dengan kantin yang login
      "kode_tr": kodeTr,
    };

    final response = await http.post(
      Uri.parse(Api.konfirmasi),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idKurir',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      print('Pesanan berhasil dibatalkan');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal membatalkan pesanan. Status code: ${response.statusCode}');
      throw Exception('Gagal membatalkan pesanan');
    }
  }

  Future<void> konfirKurir(String kodeTr, String bukti) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idKurir = prefs.getString('tokenKurir');
    print('Ini:$idKurir');
    final Map<String, String> postData = {
      "kode": "4",
      "kurir": idKurir.toString(), // sesuaikan dengan kantin yang login
      "kode_tr": kodeTr,
      "bukti_pengiriman": bukti
    };

    final response = await http.post(
      Uri.parse(Api.konfirmasi),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idKurir',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      print('Konfirmasi Selesai');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal membatalkan pesanan. Status code: ${response.statusCode}');
      throw Exception('Gagal membatalkan pesanan');
    }
  }

  Future<PesananKirim> untukDikirim() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenKurir');
    final response = await http.get(
      Uri.parse(Api.pesananUntukDikirim),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return PesananKirim.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<PesananKirim> konfirmasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenKurir');
    final response = await http.get(
      Uri.parse(Api.pesananKonfirmasi),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return PesananKirim.fromJson(jsonDecode(response.body));
    } else {
      print(response.body.toString());
      throw Exception('Gagal memuat data');
    }
  }

  Future<PesananKirim> riwayatKurir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenKurir');
    final response = await http.get(
      Uri.parse(Api.riwayatKurir),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return PesananKirim.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<PendapatanKurir> pendapatanKurir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenKurir');
    print(token);
    final response = await http.get(
      Uri.parse(Api.pendapatanKurir),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return PendapatanKurir.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<ProductCancellation> productCancellation(
      String kodeTr, String kodeMenu) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String urlData =
        "${Api.productCancellation}kode_tr=$kodeTr&kode_menu=$kodeMenu";

    final response = await http.post(
      Uri.parse(urlData),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      final value = ProductCancellation.fromJson(jsonDecode(response.body));
      if (value.kode == 1) {
        print('Pesanan berhasil dibatalkan');
        print(value.status.toString());
        return value;
      }

      print('Gagal membatalkan pesanan. Status code: ${response.body}');
      return value;
    } else {
      // Gagal membatalkan pesanan
      final value = ProductCancellation.fromJson(jsonDecode(response.body));
      print('Gagal membatalkan pesanan. Status code: ${response.statusCode}');
      return value;
    }
  }
}
