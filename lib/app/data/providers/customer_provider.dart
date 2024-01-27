import 'dart:convert';
import 'package:dikantin/app/data/models/profile_model.dart';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import '../models/biayakurir_model.dart';
import '../models/profile_kurir_model.dart';
import '../models/qr_model.dart';
import '../models/unit_model.dart';
import '../models/waktu_model.dart';

class CustomerProvider extends GetxController {
  Future<void> editAlamat(String alamat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final Map<String, dynamic> postData = {
      "alamat": alamat,
    };

    final response = await http.post(
      Uri.parse(Api.updateProfile),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      print('Berhasil di update');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal update alamat. Status code: ${response.statusCode}');
      throw Exception('Gagal membatalkan pesanan');
    }
  }

  Future<Profile> fetchDatacus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.getProfile),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Unit> getDataUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(Api.getUnit),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Unit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<ProfileKurir> fetchDatakur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenKurir');
    final response = await http.get(
      Uri.parse(Api.getProfilekurir),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ProfileKurir.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Qr> fetchqr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse(Api.tampilQr),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Qr.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<Biayakurir> fetchbiayakurir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(Api.biayakurir),
      // headers: {
      //   'Authorization':
      //       'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      // },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Biayakurir.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<waktuModel> fetchWaktu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse(Api.checkjam),
      headers: {
        'Authorization':
            'Bearer $token', // Gantilah [TOKEN] dengan token yang sesuai
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return waktuModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat datale');
    }
  }
}
