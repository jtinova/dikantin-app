import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import 'package:animations/animations.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dikantin_app_rebuild/app/models/menu_kantin.dart';

class MenuKantinView extends GetView<MenuKantinController> {
  MenuKantinView({super.key});

  @override
  final MenuKantinController controller = Get.put(MenuKantinController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF19345E),
        elevation: 0,
        title: Text(
          "Daftar Menu",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, 
            fontWeight: FontWeight.w500
          ),
        ), 
        actions: [
          IconButton(
            icon:  Icon(Icons.question_mark_rounded, color: Color(0xFFFEFEFE),),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    'Bantuan',
                    style: TextStyle(
                      color: Color(0xFF19345E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      "• Tekan tombol 'Ubah Stok' untuk mengubah status menu.\n"
                      "• Tekan tombol 'Tersedia' untuk mengubah status menjadi Tersedia.\n"
                      "• Tekan tombol 'Habis' untuk mengubah status menjadi Habis.\n",
                      style: TextStyle(fontSize: 15),
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
        )
      ),
    );
  }
}

class TabBar extends StatelessWidget {
  const TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuKantinController controller = Get.find<MenuKantinController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
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
              radius: 100,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              tabs: [
                Tab(text: "Semua"),
                Tab(text: "Makanan"),
                Tab(text: "Minuman"),
              ]
            ),
            // Expanded(
            //   child: TabBarView(
            //     children: [
            //       Center(child: Text("Content for All")),
            //       Center(child: Text("Content for Experience Consulting")),
            //       Center(child: Text("Content for Front Office Transformation")),
            //     ],
            //   ),
            // ),
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
      return Obx(() => ListView.builder(
        padding: EdgeInsets.all(14),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var menu = data[index]; 
          return Padding(
            padding: const EdgeInsets.all(12),
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
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: menu.isAvailable
                                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                                : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                            child: Image.network(
                              menu.imagePath,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -14, 
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                menu.status,
                                style: const TextStyle(
                                  color: Color(0xFF1E2857),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
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
                                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  menu.hargaFormatted,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showStockDialog(context, menu); 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF19345E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Ubah Stok",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
        }
      ));
    }

    return Expanded(
      child: buildListView(controller.daftarMenu),
    );
  }

  void _showStockDialog(BuildContext context, MenuModel menuItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Stok - ${menuItem.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status Saat Ini: ${menuItem.status}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.find<MenuKantinController>().updateMenuStock(menuItem.id, true);
                      Navigator.of(context).pop();
                    },
                    child: Text('Tersedia'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.find<MenuKantinController>().updateMenuStock(menuItem.id, false); 
                      Navigator.of(context).pop();
                    },
                    child: Text('Habis'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


