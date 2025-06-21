// ignore_for_file: avoid_print

import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/courier_profile_controller.dart';

class CourierProfileView extends GetView<CourierProfileController> {
  const CourierProfileView({super.key});

  void _handleLogout(BuildContext context) {
    try {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      authProvider.logoutUser();
      
      // Show snackbar after logout
      Get.snackbar(
        "Informasi",
        "Logout berhasil",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
          color: Colors.white,
        ),
      );
    } catch (e) {
      print("Error during logout: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat logout: $e",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Kamu yakin ingin logout?"),
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xFF1E2857)),
                        ),
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _handleLogout(context);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshData();
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Blue card with profile info
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E2857),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                // Profile image and info
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/logo_dikantin.png'),
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                    .courierData['full_name'] ??
                                                'Nama tidak tersedia',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            controller.courierData['email'] ??
                                                'Email tidak tersedia',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            controller.courierData[
                                                    'phone_number'] ??
                                                'No. HP tidak tersedia',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),

                                // Pendapatan Kurir Section
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Pendapatan Kurir',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if ((double.tryParse(controller
                                                          .courierData[
                                                              'total_balance']
                                                          ?.toString() ??
                                                      '0') ??
                                                  0) >
                                                  0)
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                _showWithdrawalConfirmation(
                                                    context);
                                              },
                                              icon: Icon(
                                                  Icons.account_balance_wallet,
                                                  size: 16,
                                                  color: Colors.white),
                                              label: Text('Tarik Dana',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF1E2857),
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                                textStyle:
                                                    TextStyle(fontSize: 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Saldo',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            controller.formatCurrency(
                                                double.tryParse(controller
                                                            .courierData[
                                                                'total_balance']
                                                            ?.toString() ??
                                                        '0') ??
                                            0),
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Pendapatan Hari Ini',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            controller.formatCurrency(
                                                double.tryParse(controller
                                                            .courierData[
                                                                'today_earnings']
                                                            ?.toString() ??
                                                        '0') ??
                                            0),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Delivery statistics
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                // For delivery
                                Expanded(
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            color: Color(0xFF1E2857),
                                            size: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${controller.courierData['pending_deliveries'] ?? 0}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Untuk Dikirim',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                // For confirmation
                                Expanded(
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Color(0xFF1E2857),
                                            size: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${controller.courierData['delivered_deliveries'] ?? 0}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Konfirmasi',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Menu options
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Riwayat Pengantaran
                                Card(
                                  elevation: 1,
                                  margin: EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.cube_box,
                                      color: Colors.grey,
                                    ),
                                    title: Text(
                                      'Riwayat Pengantaran',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () => Get.toNamed(
                                        Routes.COURIER_DELIVERY_HISTORY),
                                  ),
                                ),

                                // Informasi Aplikasi
                                Card(
                                  elevation: 1,
                                  margin: EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.info_circle,
                                      color: Colors.grey,
                                    ),
                                    title: Text(
                                      'Informasi Aplikasi',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () => Get.toNamed(Routes.ABOUT_APP),
                                  ),
                                ),

                                // Keluar
                                Card(
                                  elevation: 1,
                                  margin: EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.square_arrow_left,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Keluar',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.red),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Logout"),
                                            content: Text(
                                                "Kamu yakin ingin logout?"),
                                            backgroundColor: Colors.white,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          Color(0xFF1E2857)),
                                                ),
                                                child: Text(
                                                  "Batal",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _handleLogout(context);
                                                },
                                                child: Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),

                                // Withdrawal history if any
                                if (controller
                                    .withdrawalHistory.isNotEmpty) ...[
                                  SizedBox(height: 16),
                                  Text(
                                    'Riwayat Penarikan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        controller.withdrawalHistory.length,
                                    itemBuilder: (context, index) {
                                      final history =
                                          controller.withdrawalHistory[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            controller.formatCurrency(
                                                double.tryParse(
                                                        history['withdrawal_amount']
                                                                ?.toString() ??
                                                            '0') ??
                                                0),
                                          ),
                                          subtitle: Text(
                                              history['withdrawal_date'] ?? ''),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

void _showWithdrawalConfirmation(BuildContext context) {
  final controller = Get.find<CourierProfileController>();
  final totalBalance = double.tryParse(
          controller.courierData['total_balance']?.toString() ?? '0') ??
      0;

  // Dialog untuk memilih metode penarikan
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Pilih Metode Penarikan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Tarik Seluruh Saldo'),
              subtitle: Text(controller.formatCurrency(totalBalance)),
              onTap: () {
                Navigator.of(context).pop();
                _confirmFullWithdrawal(context, controller, totalBalance);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit_note),
              title: Text('Tarik Sebagian'),
              subtitle: Text('Atur jumlah penarikan'),
              onTap: () {
                Navigator.of(context).pop();
                _showCustomAmountDialog(context, controller, totalBalance);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
        ],
      );
    },
  );
}

// Dialog konfirmasi untuk penarikan seluruh saldo
void _confirmFullWithdrawal(BuildContext context,
    CourierProfileController controller, double totalBalance) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Tarik Seluruh Saldo'),
        content: Text(
            'Anda akan menarik seluruh saldo sebesar ${controller.formatCurrency(totalBalance)}. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.withdrawAllBalance();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E2857),
            ),
            child: Text('Tarik Dana', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

// Dialog untuk input jumlah penarikan kustom
void _showCustomAmountDialog(BuildContext context,
    CourierProfileController controller, double totalBalance) {
  final TextEditingController textController = TextEditingController();
  controller.withdrawalAmount.value = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Jumlah Penarikan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Saldo tersedia: ${controller.formatCurrency(totalBalance)}'),
            SizedBox(height: 16),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Penarikan',
                hintText: 'Masukkan jumlah',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Parse currency input
                String cleaned = value.replaceAll('.', '');
                double? amount = double.tryParse(cleaned);
                if (amount != null) {
                  controller.withdrawalAmount.value = amount;

                  // Format the text with thousand separators
                  if (value.isNotEmpty) {
                    final formatted =
                        controller.formatCurrency(amount).replaceAll('Rp ', '');
                    textController.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    double halfBalance = totalBalance / 2;
                    controller.withdrawalAmount.value = halfBalance;
                    textController.text = controller
                        .formatCurrency(halfBalance)
                        .replaceAll('Rp ', '');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: Text('50%'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.withdrawalAmount.value = totalBalance;
                    textController.text = controller
                        .formatCurrency(totalBalance)
                        .replaceAll('Rp ', '');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: Text('100%'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.withdrawalAmount.value > 0 &&
                        controller.withdrawalAmount.value <= totalBalance
                    ? () {
                        Navigator.of(context).pop();
                        _confirmPartialWithdrawal(context, controller,
                            controller.withdrawalAmount.value);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E2857),
                ),
                child: Text('Lanjutkan', style: TextStyle(color: Colors.white)),
              )),
        ],
      );
    },
  );
}

// Dialog konfirmasi untuk penarikan sebagian saldo
void _confirmPartialWithdrawal(
    BuildContext context, CourierProfileController controller, double amount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi Penarikan'),
        content: Text(
            'Anda akan menarik dana sebesar ${controller.formatCurrency(amount)}. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.withdrawPartialBalance(amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E2857),
            ),
            child: Text('Tarik Dana', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
