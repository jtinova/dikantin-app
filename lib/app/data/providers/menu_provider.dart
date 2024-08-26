// ignore_for_file: unused_import

import 'dart:convert';
import 'package:dikantin/app/data/models/kantin_model.dart';
import 'package:dikantin/app/data/models/menu_model.dart';
import 'package:dikantin/app/data/models/version_model.dart';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/penjualan_model.dart';
import '../models/recommendation_model.dart';
import '../models/search_model.dart';
import '../models/riwayat_model.dart';

class MenuProvider extends GetxController {
  Future<Search> searchSemua(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(Api.semua + keyword), // Sesuaikan URL pencarian dengan API Anda
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal melakukan pencarian');
    }
  }

  Future<Kantin> fetchKantin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(Api.daftarKantin), // Sesuaikan URL pencarian dengan API Anda
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Kantin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal melakukan pencarian');
    }
  }

  Future<Search> fetchMenuKantin(String idKantin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(Api.daftarMenuKantin + idKantin),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal melakukan pencarian');
    }
  }

  Future<Search> searchMakanan(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.makanan + keyword),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Version> checkVersion() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.checkversion),
      // headers: {
      //   'Authorization':
      //       'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      // },
    );
    print(response.body);

    if (response.statusCode == 200) {
      return Version.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Search> searchMinuman(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.minuman + keyword),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Search> searchSnack(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.snack + keyword),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Search> fetchDataDiskon(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.diskon + keyword),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Penjualan> fetchDataPenjualanHariIni() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.penjualanHariIni),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Penjualan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }
  
  Future<Recommendation> fetchDataRecommendationMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.rekomendasiMenu),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Recommendation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<http.Response> postOrder(
      List<Datasearch> cartList,
      Map<String, dynamic> detailOrderan,
      Map<int, int> itemQuantities,
      Map<int, String> itemNotes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse(Api.transaksi); // Pastikan ini adalah URL yang benar

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    List<Map<String, dynamic>> orderanData = cartList.map((item) {
      final int quantity = itemQuantities[item.idMenu!] ?? 1;
      final num discountAmount = item.diskon != null
          ? (item.harga! * item.diskon! / 100) * quantity
          : 0;
      final num totalPrice = (item.harga! * quantity) - discountAmount;
      return {
        "kode_menu": item.idMenu,
        "qty_barang": quantity,
        "total_harga_barang": totalPrice,
        "catatan": itemNotes[item.idMenu!], // Menyertakan catatan
      };
    }).toList();

    Map<String, dynamic> body = {
      "detail_orderan": detailOrderan,
      "orderan": orderanData,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      // Jika status code bukan 200, cetak body untuk debugging
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
    }

    return response;
  }

  Future<http.Response> postOrderOnline(
      List<Datasearch> cartList,
      Map<String, dynamic> detailOrderan,
      Map<int, int> itemQuantities,
      Map<int, String> itemNotes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse(
        Api.transaksiPilihOnline); // Pastikan ini adalah URL yang benar

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    List<Map<String, dynamic>> orderanData = cartList.map((item) {
      final int quantity = itemQuantities[item.idMenu!] ?? 1;
      final num discountAmount = item.diskon != null
          ? (item.harga! * item.diskon! / 100) * quantity
          : 0;
      final num totalPrice = (item.harga! * quantity) - discountAmount;
      return {
        "kode_menu": item.idMenu,
        "qty_barang": quantity,
        "total_harga_barang": totalPrice,
        "catatan": itemNotes[item.idMenu!], // Menyertakan catatan
      };
    }).toList();

    Map<String, dynamic> body = {
      "detail_orderan": detailOrderan,
      "orderan": orderanData,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      // Jika status code bukan 200, cetak body untuk debugging
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
    }

    return response;
  }

  Future<Search> searchMenuKantin(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.makanan + keyword),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );

    if (response.statusCode == 200) {
      return Search.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }
}
