// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_client_service.dart';
import '../../../service/api_service.dart';
import '../../../models/cart.dart';
import '../../order/controllers/order_controller.dart';

class CheckoutController extends GetxController {
  var selectedDeliveryOption = ''.obs;
  var selectedPaymentType = ''.obs;
  var tableNumber = ''.obs;
  var calculateResult = Rxn<Map<String, dynamic>>();
  var groupedItemsByCanteen = <String, List<Map<String, dynamic>>>{}.obs;

  var itemForCheckout = <CartItem>[].obs;
  var checkoutNoteController = <String, TextEditingController>{}.obs;

  // Menyimpan biaya subtotal menu dan biaya ongkir asli
  var menuSubtotal = 0.obs;
  var originalDeliveryFee = 0.obs;

  @override
  void onInit() {
    super.onInit();

    ever(selectedDeliveryOption, (String option) {
      if (calculateResult.value != null) {
        Map<String, dynamic> newResult =
            Map<String, dynamic>.from(calculateResult.value!);

        if (option == 'delivery') {
          newResult['biaya_ongkir'] = originalDeliveryFee.value;
          newResult['total_biaya_pembayaran'] =
              menuSubtotal.value + originalDeliveryFee.value;
        } else {
          newResult['biaya_ongkir'] = 0;
          newResult['total_biaya_pembayaran'] = menuSubtotal.value;
        }

        calculateResult.value = newResult;
      }
    });
  }

  void initializeCheckoutData(List<CartItem> itemsFromCart) {
    itemForCheckout.assignAll(itemsFromCart);

    // Buang controller lama jika ada
    checkoutNoteController.forEach((_, ctrl) => ctrl.dispose());
    checkoutNoteController.clear();

    // Buat controller baru untuk setiap item di halaman checkout
    for (var item in itemForCheckout) {
      final noteCtrl = TextEditingController(text: item.note ?? '');
      checkoutNoteController[item.menu.id] = noteCtrl;
      noteCtrl.addListener(() {
        final index =
            itemForCheckout.indexWhere((i) => i.menu.id == item.menu.id);
        if (index != -1) {
          itemForCheckout[index] = itemForCheckout[index].copyWith(
              note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim());
        }
      });
    }

    if (itemForCheckout.isNotEmpty) {
      getCalculate(itemForCheckout);
    }
  }

  TextEditingController getCheckoutNoteControllerForItem(String menuId) {
    if (!checkoutNoteController.containsKey(menuId)) {
      final item = itemForCheckout.firstWhereOrNull((i) => i.menu.id == menuId);
      checkoutNoteController[menuId] =
          TextEditingController(text: item?.note ?? '');
      checkoutNoteController[menuId]?.addListener(() {
        final index =
            itemForCheckout.indexWhere((i) => i.menu.id == item?.menu.id);
        if (index != -1) {
          itemForCheckout[index] = itemForCheckout[index].copyWith(
              note: checkoutNoteController[menuId]?.text.trim().isEmpty ?? true
                  ? null
                  : checkoutNoteController[menuId]?.text.trim());
        }
      });
    }
    return checkoutNoteController[menuId]!;
  }

  Future<void> getCalculate(List<CartItem> selectedItems) async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.calculateOrder;

    List<Map<String, dynamic>> menuPayload = selectedItems.map((item) {
      String? note =
          checkoutNoteController[item.menu.id]?.text.trim() ?? item.note;
      return {
        "id": item.menu.id,
        "qty": item.quantity,
        "note": (note == null || note.isEmpty) ? null : note,
      };
    }).toList();

    try {
      final req = await ApiClient.post(
        url,
        body: {"menu": menuPayload},
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        calculateResult.value = res['data'];

        int grandTotal = res['data']['total_biaya_pembayaran'] ?? 0;
        int deliveryFee = res['data']['biaya_ongkir'] ?? 0;

        menuSubtotal.value = grandTotal - deliveryFee;
        originalDeliveryFee.value = deliveryFee;

        selectedDeliveryOption.trigger(selectedDeliveryOption.value);

        if (res['data'] != null && res['data']['details'] != null) {
          groupItemsForDisplay(res['data']['details'] as List<dynamic>);
        }
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "${res['message']}",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> createOrder({
    required String tipePesan,
    required String metodePembayaran,
    required String gedung,
    required String detailLokasi,
  }) async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.createOrder;

    if (gedung == '' && tipePesan == 'delivery') {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Gedung Tujuan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    } else if (detailLokasi == '' && tipePesan == 'delivery') {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Mohon Lengkapi Detail Lokasi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    } else if (tableNumber.isEmpty && tipePesan == 'dine_in') {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Mohon Lengkapi Nomor Meja",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    } else if (tipePesan.isEmpty) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Opsi Pesanan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    } else if (metodePembayaran.isEmpty) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Metode Pembayaran",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    }

    List<Map<String, dynamic>> menuPayload = itemForCheckout.map((item) {
      String? note = checkoutNoteController[item.menu.id]?.text.trim();
      return {
        "id": item.menu.id,
        "qty": item.quantity,
        "note": (note == null || note.isEmpty) ? null : note,
      };
    }).toList();

    // Request Body
    Map<String, dynamic> requestBody = {
      "tipe_pesanan": tipePesan,
      "metode_pembayaran": metodePembayaran,
      "id_gedung": gedung,
      "detail_tujuan": detailLokasi,
      "menu": menuPayload,
    };

    // Tambahkan nomor meja jika pesanan adalah "dine_in"
    if (tipePesan == 'dine_in') {
      requestBody['no_meja'] = int.parse(tableNumber.value);
    }

    try {
      final req = await ApiClient.post(
        url,
        body: requestBody,
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        if (Get.isRegistered<OrderController>()) {
          final orderController = Get.find<OrderController>();
          await orderController.refreshAll();
        }

        Get.snackbar(
          "Pesanan Berhasil",
          "Pesanan Anda Berhasil Dibuat",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );

        return true;
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "${res['message']}",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }

      return false;
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return false;
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> groupItemsForDisplay(List<dynamic> apiDetails) async {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var apiDetailItem in apiDetails) {
      final String canteenName =
          apiDetailItem['canteen'] ?? 'Tanpa Nama Kantin';
      if (!grouped.containsKey(canteenName)) {
        grouped[canteenName] = [];
      }

      final String menuIdFromApi = apiDetailItem['id']?.toString() ?? '';

      Map<String, dynamic> displayItem =
          Map<String, dynamic>.from(apiDetailItem);
      displayItem['menu_id_for_controller'] =
          menuIdFromApi; // Kunci untuk controller

      grouped[canteenName]!.add(displayItem);
    }
    groupedItemsByCanteen.value = grouped;
  }

  String getDeliveryOptionTitle(String value) {
    switch (value) {
      case 'dine_in':
        return 'Ditempat (Dine In)';
      case 'delivery':
        return 'Diantar (Delivery)';
      case 'take_away':
        return 'Diambil (Take Away)';
      default:
        return 'Pilih Opsi';
    }
  }

  String getPaymentTypeTitle(String value) {
    switch (value) {
      case 'cash':
        return 'Cash';
      case 'qris':
        return 'QRIS';
      default:
        return 'Pilih Opsi';
    }
  }

  String formatRupiah(dynamic price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    final safePrice = (price ?? 0) as int;
    return formatCurrency.format(safePrice);
  }

  String formatPhoneNumber(String number) {
    if (number.startsWith('0')) {
      number = '+62${number.substring(1)}';
    }

    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if (i == 2 || i == 6 || i == 10 || i == 14) {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }

  @override
  void onClose() {
    checkoutNoteController.forEach((_, controller) => controller.dispose());
    checkoutNoteController.clear();
    super.onClose();
  }
}
