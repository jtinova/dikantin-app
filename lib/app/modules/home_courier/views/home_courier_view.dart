// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../controllers/home_courier_controller.dart';

class HomeCourierView extends GetView<HomeCourierController> {
  HomeCourierView({super.key}) {
    // Pastikan controller sudah terinisialisasi sebelum widget dibuat
    Get.put(HomeCourierController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        // Menggunakan FutureBuilder untuk memastikan controller sudah siap
        future: Future.delayed(Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          // Gunakan GetX untuk mengakses controller yang sudah diinisialisasi
          return GetX<HomeCourierController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // Header dengan info saldo
                  Container(
                    height: 240,
                    color: Color(0xFF1E2857),
                    padding: EdgeInsets.all(20),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Saldo Anda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        controller.isBalanceVisible.value
                                            ? controller.formatCurrency(
                                                (controller.courierData[
                                                            'total_balance'] ??
                                                        0)
                                                    .toDouble())
                                            : '• • • • • •',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(
                                      controller.isBalanceVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      controller.isBalanceVisible.value =
                                          !controller.isBalanceVisible.value;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              controller.showWithdrawalHistory();
                            },
                            child: Text(
                              'Riwayat Penarikan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Judul daftar pickup pesanan
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Daftar Pickup Pesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Menggunakan widget DefaultTabController sebagai gantinya
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // Tab untuk kategori pesanan
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: customTabBar(),
                          ),

                          // Daftar pesanan berdasarkan tab
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Tab 1: Untuk Dikirim
                                RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.getPendingOrders();
                                    await controller.getProfile();
                                  },
                                  child: controller.pendingOrders.isEmpty
                                      ? ListView(
                                          children: [
                                            SizedBox(height: 50),
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Menggunakan file JSON lokal dari assets/animations
                                                  Lottie.asset(
                                                    'assets/animations/Animation - 1746119107847.json',
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      print(
                                                          "Error loading Lottie: $error");
                                                      return Icon(
                                                        CupertinoIcons.cube_box,
                                                        size: 80,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: 16),
                                                  // Text(
                                                  //   'Belum ada pesanan yang harus di pickup',
                                                  //   style: TextStyle(
                                                  //     fontSize: 16,
                                                  //     color: Colors.grey[600],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              controller.pendingOrders.length,
                                          padding: EdgeInsets.all(10),
                                          itemBuilder: (context, index) {
                                            final order =
                                                controller.pendingOrders[index];
                                            return Card(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: ListTile(
                                                onTap: () {
                                                  showOrderDetail(
                                                      context, order);
                                                },
                                                title: Text(
                                                  order['building_name'] ??
                                                      'Lokasi tidak tersedia',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.formatCurrency(
                                                          (order['grand_total'] ??
                                                                  0)
                                                              .toDouble()),
                                                    ),
                                                    Text(
                                                      order['destination_detail'] ??
                                                          'Detail lokasi tidak tersedia',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: getStatusColor(
                                                        order['status']),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    getStatusText(
                                                        order['status']),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),

                                // Tab 2: Konfirmasi
                                RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.getPendingOrders();
                                    await controller.getProfile();
                                  },
                                  child: controller.deliveredOrders.isEmpty
                                      ? ListView(
                                          children: [
                                            SizedBox(height: 50),
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Menggunakan file JSON lokal dari assets/images
                                                  Lottie.asset(
                                                    'assets/images/Animation - 1746119107847.json',
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      print(
                                                          "Error loading Lottie: $error");
                                                      return Icon(
                                                        CupertinoIcons
                                                            .check_mark_circled,
                                                        size: 80,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: 16),
                                                  // Text(
                                                  //   'Belum ada pesanan yang perlu dikonfirmasi',
                                                  //   style: TextStyle(
                                                  //     fontSize: 16,
                                                  //     color: Colors.grey[600],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              controller.deliveredOrders.length,
                                          padding: EdgeInsets.all(10),
                                          itemBuilder: (context, index) {
                                            final order = controller
                                                .deliveredOrders[index];
                                            return Card(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: ListTile(
                                                onTap: () {
                                                  showOrderDetail(
                                                      context, order);
                                                },
                                                title: Text(
                                                  order['building_name'] ??
                                                      'Lokasi tidak tersedia',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.formatCurrency(
                                                          (order['grand_total'] ??
                                                                  0)
                                                              .toDouble()),
                                                    ),
                                                    Text(
                                                      order['destination_detail'] ??
                                                          'Detail lokasi tidak tersedia',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: getStatusColor(
                                                        order['status']),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    getStatusText(
                                                        order['status']),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Widget TabBar Custom
  Widget customTabBar() {
    return StatefulBuilder(builder: (context, setState) {
      final tabController = DefaultTabController.of(context);

      // Tambahkan listener untuk update tampilan saat tab berubah
      void updateState() {
        setState(() {});
      }

      // Pasang dan lepas listener
      if (tabController != null) {
        // Bersihkan listener lama bila ada
        tabController.removeListener(updateState);
        // Pasang listener baru
        tabController.addListener(updateState);
      }

      return Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: tabItem(index: 0, title: 'Untuk Dikirim'),
            ),
            Expanded(
              child: tabItem(index: 1, title: 'Konfirmasi'),
            ),
          ],
        ),
      );
    });
  }

  // Widget Item Tab
  Widget tabItem({required int index, required String title}) {
    return Builder(
      builder: (context) {
        final tabController = DefaultTabController.of(context);
        final bool isSelected = tabController.index == index;

        return GestureDetector(
          onTap: () {
            tabController.animateTo(index);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF1E2857) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF1E2857),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showOrderDetail(BuildContext context, Map<String, dynamic> order) async {
    // Lanjutkan untuk mengambil detail lainnya dari API
    final details = await controller.getOrderDetail(order['id'].toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            if (details.isNotEmpty &&
                details['customer_information'] != null) ...[
              DetailRow(
                title: 'Pelanggan',
                value: details['customer_information']['full_name'] ?? '-',
              ),
              DetailRow(
                title: 'No. Telepon',
                value: details['customer_information']['phone_number'] ?? '-',
              ),
              DetailRow(
                title: 'Lokasi',
                value:
                    '${details['customer_information']['building_name'] ?? '-'}\n${details['customer_information']['destination_detail'] ?? '-'}',
              ),
            ],
            if (details.isNotEmpty &&
                details['transaction_summary'] != null) ...[
              DetailRow(
                title: 'Total Item',
                value:
                    '${details['transaction_summary']['total_qty'] ?? 0} items',
              ),
              DetailRow(
                title: 'Total Harga',
                value: controller.formatCurrency(
                    (details['transaction_summary']['total_selling_cost'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Biaya Antar',
                value: controller.formatCurrency(
                    (details['transaction_summary']['delivery_fee'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Total Pembayaran',
                value: controller.formatCurrency(
                    (details['transaction_summary']['grand_total'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Metode Pembayaran',
                value: controller.capitalizeFirst(
                    details['transaction_summary']['payment_method'] ?? '-'),
              ),
            ],
            SizedBox(height: 20),
            if (order['status'] == 'pending')
              ElevatedButton(
                onPressed: () {
                  controller.updateOrderToDelivered(order['id'].toString());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E2857),
                  minimumSize: Size(double.infinity, 45),
                ),
                child:
                    Text('Mulai Antar', style: TextStyle(color: Colors.white)),
              ),
            if (order['status'] == 'delivered')
              ElevatedButton(
                onPressed: () {
                  // Cukup panggil completeOrder tanpa parameter
                  controller.completeOrder();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 45),
                ),
                child: Text('Selesaikan Pesanan',
                    style: TextStyle(color: Colors.white)),
              ),
            if (order['status'] == 'delivered')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Scan barcode dari pelanggan untuk menyelesaikan pesanan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'delivered':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Siap Antar';
      case 'delivered':
        return 'Sedang Diantar';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}