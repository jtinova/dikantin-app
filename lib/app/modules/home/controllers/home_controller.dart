import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import '../../../data/models/biayakurir_model.dart';
import '../../../data/models/penjualan_model.dart';
import '../../../data/models/recommendation_model.dart';
import '../../../data/models/search_model.dart';
import '../../../data/models/waktu_model.dart';
import '../../../data/providers/customer_provider.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../data/providers/services.dart';
import '../../order/controllers/order_controller.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController catatanController = TextEditingController();
  final notesMap = <int, String>{}.obs;
  late AnimationController animationController;
  late AnimationController _controller;
  late TabController tabController; // Tambahkan variabel TabController
  final searchResults = <Datasearch>[].obs;
  final menuProvider = MenuProvider().obs;
  late Penjualan penjualan = Penjualan();
  late Recommendation rekomendasi = Recommendation();
  var cartList = <Datasearch>[].obs;
  var penjualanD = <Data>[].obs;
  var rekomendasiD = <DataRekomendasi>[].obs;

  var itemQuantities = <int, int>{}.obs;
  final isLoading = false.obs; // Tambahkan isLoading
  final isCashSelected = true.obs;
  final isPolijePaySelected = false
      .obs; // Digunakan untuk memantau apakah metode pembayaran Polije Pay dipilih
  Rx<Biayakurir> biayaData = Biayakurir().obs;
  Rx<waktuModel> waktuData = waktuModel().obs;
  final _customerProvider = CustomerProvider().obs;

// Menghitung total harga dari semua item di keranjang, termasuk kuantitas dan diskon
  int get totalPrice {
    int total = 0;
    for (var item in cartList) {
      int itemTotal = calculatePriceAfterDiscount(item) *
          (itemQuantities[item.idMenu] ?? 1);
      total += itemTotal;
    }
    return total;
  }

  int get totalPriceWithKurir {
    int total = 0;
    for (var item in cartList) {
      int itemTotal = calculatePriceAfterDiscount(item) *
          (itemQuantities[item.idMenu] ?? 1);
      total += itemTotal;
    }
    // Menambahkan biaya kirim ke total harga
    final biayakirim = OrderController().calculateValueBasedOnRange() ?? 0;
    total += biayakirim;
    return total;
  }

  late int nominalUserBayar = totalPriceWithKurir;

  int get countc => cartList.length;

  int get count {
    return itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Calculate discount for each item
  int calculateDiscount(Datasearch item) {
    // Check for null and return 0 if discount is null
    int discount = item.diskon ?? 0;
    return (item.harga! * discount) ~/ 100;
  }

  // Calculate price after discount for each item
  int calculatePriceAfterDiscount(Datasearch item) {
    // Subtract the discount from the item's price
    return item.harga! - calculateDiscount(item);
  }

  // Get total price after all discounts have been applied
  int get totalPriceAfterDiscount =>
      cartList.fold(0, (sum, item) => sum + calculatePriceAfterDiscount(item));

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Sesuaikan durasi animasi
      vsync: this,
    );
    tabController = TabController(length: 6, vsync: this);

    fetchDataDiskon('');
    fetchDataPenjualan();
    fetchRecommedationMenu();
    refreshData();
    fetchbiayakurir();

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus(
      androidId: 'com.mobile.legends',
      // androidPlayStoreCountry: "es_ES",
      androidHtmlReleaseNotes: true,
    );

    const simpleBehavior = true;

    // if (simpleBehavior) {
    basicStatusCheck(newVersion);
    // }
    // else {
    // advancedStatusCheck(newVersion);
    // }
  }

  @override
  void onClose() {
    _controller.dispose();
    tabController.dispose();
    super.onClose();
  }

  void saveNoteForMenu(int idMenu, String note) {
    notesMap[idMenu] = note;
  }

  String getNoteForMenu(int idMenu) {
    return notesMap[idMenu] ?? '';
  }

  void clearNoteForMenu(int idMenu) {
    notesMap.remove(idMenu);
  }

  basicStatusCheck(NewVersionPlus newVersion) async {
    final version = await newVersion.getVersionStatus();
    if (version != null) {
      String release = version.releaseNotes ?? "";
    }
    newVersion.showAlertIfNecessary(
      context: Get.context!,
      launchModeVersion: LaunchModeVersion.external,
    );
    print('Status local: ${version!.localVersion}');
    print('Status store: ${version.appStoreLink}');
    print('Status store: ${version.storeVersion}');
    print('Status store: ${version.releaseNotes}');
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: Get.context!,
        versionStatus: status,
        dialogText: 'Custom Text',
        launchModeVersion: LaunchModeVersion.external,
        allowDismissal: false,
      );
    }
  }

  void addToCart(Datasearch item, String note) async {
    try {
      int idMenu = item.idMenu!;

      // Fetch waktu data
      waktuModel result = await _customerProvider.value.fetchWaktu();

      // Check if the response status code is 200
      if (result.code == 200) {
        // Execute addToCart logic
        if (!cartList.any((element) => element.idMenu == item.idMenu)) {
          cartList.add(item);
          itemQuantities[item.idMenu!] = 1;
          saveNoteForMenu(item.idMenu!, catatanController.text);
        } else {
          addQuantity(item.idMenu!);
        }
        // Save or update the note for the item
        notesMap[idMenu] = note;

        // Refresh itemQuantities and notesMap
        itemQuantities.refresh();
        notesMap.refresh();
      } else {
        // Show error Snackbar if the response status code is not 200
        Get.snackbar(
          'Mohon maaf',
          result.data.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Mohon maaf',
        'Batas Pelayanan .',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  void removeFromCart(Datasearch item) {
    int idMenu = item.idMenu!;
    clearNoteForMenu(idMenu);
    cartList.removeWhere((element) => element.idMenu == item.idMenu);
    itemQuantities.remove(item.idMenu); // Ini akan menghapus kuantitas dari map
    itemQuantities.refresh();
    notesMap.refresh();
// Memperbarui observers agar jumlah total kuantitas diperbarui di UI
    update(); // Memanggil update untuk memicu pembaruan UI pada widget yang terkait
  }

  void startAnimation() {
    _controller.forward();
  }

  void addQuantity(int idMenu) {
    if (itemQuantities.containsKey(idMenu)) {
      itemQuantities[idMenu] = (itemQuantities[idMenu] ?? 1) + 1;
    } else {
      itemQuantities[idMenu] =
          1; // Jika item belum ada dalam map, set kuantitas ke 1
    }
    itemQuantities.refresh(); // Memperbarui UI
  }

  void subtractQuantity(int idMenu) {
    if (itemQuantities.containsKey(idMenu) && itemQuantities[idMenu]! > 1) {
      itemQuantities[idMenu] = (itemQuantities[idMenu] ?? 1) - 1;
      itemQuantities.refresh(); // Memperbarui UI
    }
  }

  void setLoading(bool value) {
    isLoading.value = value; // Metode untuk mengatur status isLoading
  }

  Future<void> fetchDataDiskon(String keyword) async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await menuProvider.value.fetchDataDiskon(keyword);
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }

  Future<void> fetchWaktu() async {
    try {
      isLoading(true);

      // Call the fetchqr method from CustomerProvider
      waktuModel result = await _customerProvider.value.fetchWaktu();

      // Update the qr data
      waktuData(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching biaya kurir data: $error');
    }
  }

  Future<void> fetchbiayakurir() async {
    try {
      isLoading(true);

      // Call the fetchqr method from CustomerProvider
      Biayakurir result = await _customerProvider.value.fetchbiayakurir();

      // Update the qr data
      biayaData(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching biaya kurir data: $error');
    }
  }

  int calculateSubtotal(int idMenu) {
    final int price = calculatePriceAfterDiscount(findMenuById(idMenu));
    final int quantity = itemQuantities[idMenu] ?? 1;
    return price * quantity;
  }

  Datasearch findMenuById(int idMenu) {
    return cartList.firstWhere((menu) => menu.idMenu == idMenu,
        orElse: () => Datasearch());
  }

  Future<void> fetchDataPenjualan() async {
    try {
      isLoading(true);
      final result = await menuProvider.value.fetchDataPenjualanHariIni();
      penjualan = result;
      penjualanD.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchRecommedationMenu() async {
    try {
      isLoading(true);
      final result = await menuProvider.value.fetchDataRecommendationMenu();
      rekomendasi = result;
      rekomendasiD.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> refreshData() async {
    await fetchDataDiskon('');
    await fetchDataPenjualan();
    await fetchRecommedationMenu();
  }

  void setCartList(List<Datasearch> updatedCartList) {
    cartList.assignAll(updatedCartList);
  }

  Future<void> submitOrder() async {
    setLoading(true); // Menampilkan indikator loading
    String paymentMethod = isCashSelected.value
        ? "cash"
        : isPolijePaySelected.value
            ? "qris"
            : "Unknown Payment Method";

    int totalBayar;

    if (paymentMethod == "cash") {
      totalBayar = nominalUserBayar;
    } else {
      totalBayar = totalPriceWithKurir;
    }
    int biayaKirim = OrderController().calculateValueBasedOnRange() ?? 2000;

    Map<String, dynamic> detailOrderan = {
      "total_harga": totalPrice,
      "total_bayar": totalBayar,
      "biaya_kirim": biayaKirim,
      "kembalian": totalBayar - totalPriceWithKurir,
      "model_pembayaran": paymentMethod
    };

    final response = await menuProvider.value.postOrder(
      cartList,
      detailOrderan,
      itemQuantities,
      notesMap.toJson(),
    );

    if (response.statusCode == 200) {
      // Proses order berhasil
      Get.snackbar(
        'Berhasil',
        'Terimakasih sudah order di aplikasi Dikantin',
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      ); // Reset cart dan quantities atau navigasi ke halaman berikutnya
      cartList.clear();
      itemQuantities.clear();
      notesMap.clear();
      catatanController.clear(); // Mengosongkan notesMap setelah order berhasil
    } else {
      // Proses order gagal
      // Get.snackbar("Error", "Failed to submit order: ${response.bodyBytes}");
      Get.snackbar(
        'Peringatan',
        response.body,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
    // } catch (e) {
    //   // Menangani kesalahan yang mungkin terjadi selama request
    //   Get.snackbar(
    //     'Error',D
    //     '${e}',
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     duration: uration(seconds: 2),
    //     snackPosition: SnackPosition.TOP,
    //   );
    // } finally {
    //   setLoading(false); // Menutup indikator loading
    // }
  }

  Future<void> submitOrderOnline() async {
    setLoading(true); // Menampilkan indikator loading
    String paymentMethod = isCashSelected.value
        ? "Cash"
        : isPolijePaySelected.value
            ? "Qris"
            : "Unknown Payment Method";
    Map<String, dynamic> detailOrderan = {
      "total_harga": totalPrice,
      "model_pembayaran": paymentMethod
    };

    try {
      final response = await menuProvider.value.postOrderOnline(
        cartList,
        detailOrderan,
        itemQuantities,
        notesMap.toJson(), // Mengambil catatan dari notesMap
      );

      if (response.statusCode == 200) {
        // Proses order berhasil
        Get.snackbar("Success", "Order submitted successfully");
        // Reset cart dan quantities atau navigasi ke halaman berikutnya
        cartList.clear();
        itemQuantities.clear();
        notesMap.clear();
        catatanController
            .clear(); // Mengosongkan notesMap setelah order berhasil
      } else {
        // Proses order gagal
        Get.snackbar("Error", "Failed to submit order: ${response.body}");
      }
    } catch (e) {
      // Menangani kesalahan yang mungkin terjadi selama request
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      setLoading(false); // Menutup indikator loading
    }
  }

  Future<void> ngapek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idCustomer = prefs.getString('id_customer');

    final response = await http.post(
      Uri.parse(Api.getToken),
      body: {
        'id_customer': idCustomer, // Ganti dengan informasi unik dari pengguna
      },
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      final jsonResponse = jsonDecode(response.body);

      final newToken = jsonResponse['data']['token'];
      print(newToken);
      print('c');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal ambil data. Status code: ${response.statusCode}');
      throw Exception('Gagal ambil data');
    }
  }
}
