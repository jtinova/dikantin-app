import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import 'package:animations/animations.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';


class MenuKantinView extends GetView<MenuKantinController> {
  MenuKantinView({super.key});

  @override
  final MenuKantinController controller = Get.put(MenuKantinController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Daftar Menu",
          style: TextStyle(
            color: Color(0xFF403E3E),
            fontSize: 20, 
            fontWeight: FontWeight.w500
          ),
        ),  
        actions: [
          IconButton(
            icon:  Icon(Icons.question_mark_rounded),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(),
            Expanded(child: ListMenu()),
          ],
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
  const ListMenu ({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuKantinController controller = Get.find<MenuKantinController>();

    Widget buildListView(RxList<Map<String, dynamic>> data) {
      return Obx(() => ListView.builder(
        padding: EdgeInsets.all(14),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var controller = data[index];
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
                            colorFilter: controller["status"] == "Habis"
                                ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                                : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                            child: Image.asset(
                              controller["image"]!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
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
                                controller["status"]!,
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
                                  controller["nama"]!,
                                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  controller["harga"]!,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showStockDialog(context, data[index]); 
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
                      )
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

  void _showStockDialog(BuildContext context, Map<String, dynamic> menuItem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ubah Stok - ${menuItem["nama"]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Status Saat Ini: ${menuItem["status"]}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    menuItem["status"] = "Tersedia";
                    Get.find<MenuKantinController>().updateMenu(menuItem);
                    Navigator.of(context).pop();
                  },
                  child: Text('Tersedia'),
    
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    menuItem["status"] = "Habis";
                    Get.find<MenuKantinController>().updateMenu(menuItem);
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