// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dikantin_partner/app/models/menu_kantin.dart';

class MenuKantinView extends GetView<MenuKantinController> {
  MenuKantinView({super.key});

  @override
  final MenuKantinController controller = Get.put(MenuKantinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        title: Text(
          "Daftar Menu",
          style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.question_mark_rounded,
              color: Color(0xFFFEFEFE),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  title: Text(
                    'Bantuan',
                    style: TextStyle(
                      color: Color(0xFF19345E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      "• Tekan tombol 'Ubah Stok' untuk mengubah jumlah stok menu.\n"
                      "• Masukkan jumlah stok yang baru pada kolom yang tersedia.\n"
                      "• Tekan 'Simpan' untuk memperbarui stok.\n",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Tutup',
                        style: TextStyle(color: Color(0xFF19345E)),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TabBar(),
            Expanded(child: ListMenu()),
          ],
        ),
      )),
    );
  }
}

class TabBar extends StatelessWidget {
  const TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MenuKantinController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ButtonsTabBar(
                backgroundColor: Color(0xFF1E2857),
                unselectedBackgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
                // borderWidth: 1,
                // unselectedBorderColor: Colors.blue,
                radius: 100.r,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                tabs: [
                  Tab(text: "Semua"),
                  Tab(text: "Makanan"),
                  Tab(text: "Minuman"),
                ]),
          ],
        ),
      ),
    );
  }
}

class ListMenu extends StatelessWidget {
  const ListMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuKantinController controller = Get.find<MenuKantinController>();

    Widget buildListView(RxList<MenuModel> data) {
      return Obx(
        () => ListView.builder(
          padding: EdgeInsets.all(10.w),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var menu = data[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: ColorFiltered(
                              colorFilter: menu.isAvailable
                                  ? const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    )
                                  : const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                              child: Image.network(
                                menu.imagePath,
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 60.w,
                                  height: 60.h,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10.h,
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  menu.statusLabel,
                                  style: TextStyle(
                                    color: Color(0xFF1E2857),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.name,
                                    style: TextStyle(
                                      color: Color(0xFF403E3E),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "Rp ${controller.formatRupiah(menu.hargaFormatted)}",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showUpdateStockDialog(context, menu);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19345E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ).h,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Ubah Stok",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return buildListView(controller.daftarMenu);
  }

  void _showUpdateStockDialog(BuildContext context, MenuModel menuItem) {
    final TextEditingController _stockController = TextEditingController();
    _stockController.text = menuItem.stock.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Stok ${menuItem.name}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan jumlah stok baru:',
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Jumlah Stok",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? newStock = int.tryParse(_stockController.text);

                if (newStock != null && newStock >= 0) {
                  Get.find<MenuKantinController>()
                      .updateMenuStock(menuItem.id, newStock);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar(
                    "Input Tidak Valid",
                    "Harap masukkan angka yang benar (minimal 0).",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF1E2857),
              ),
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
