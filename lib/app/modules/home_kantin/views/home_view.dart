import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:animations/animations.dart';
import '../views/detail_pesanan.dart';


class HomeKantinView extends GetView<HomeController> {
  HomeKantinView({super.key});

  @override
  final HomeController controller = Get.put(HomeController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFFEFEFE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Expanded(child: Pesanan()),
            ],
          ),
        ) 
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    
    return Container(
      height: 170,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: Color(0xFF1E2857),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kantin Emak",
              style: TextStyle(color: Colors.white, fontSize: 16,
              ),
            ),
            SizedBox(height: 5,),
            PopupMenuButton(
              onSelected: (value) {
                controller.selectedItem.value = value; 
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "Buka", child: Text("Buka")),
                PopupMenuItem(value: "Tutup", child: Text("Tutup")),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                        controller.selectedItem.value,
                        style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500,),
                      )),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: controller.tabController,
                isScrollable: false, 
                labelColor: Color(0xFF1E2857), 
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab, 
                indicator: BoxDecoration(
                  color: Color(0xFFE4E2E2),
                  borderRadius: BorderRadius.circular(10), 
                ),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "Pesanan Masuk"),
                  Tab(text: "Dimasak"),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    
    Widget buildListView(RxList<Map<String, dynamic>> data) {
      return Obx(() => ListView.builder(
        padding: EdgeInsets.all(14),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item["image"]!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      ),
                      SizedBox(width: 10), 
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["id"]!,
                              style: TextStyle(
                                color: Color(0xFF403E3E), 
                                fontSize: 16, 
                                fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  item["datetime"]!,
                                  style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13,), 
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.circle, size: 5, color: Color(0xFF7C7C7C),),
                                ),
                                Text(
                                  item["status"]!,
                                  style: TextStyle(
                                    color: item["status"] == "Dimasak" ? Colors.green : Colors.red,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              (item["pesanan"] as List<dynamic>)
                                  .map((menu) => "${menu["jumlah"]} ${menu["nama"]}")
                                  .join(", "),
                              style: TextStyle(color: Color(0xFF585858), fontSize: 15),
                            ),
                          ]
                        )
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: Color(0xFFD9D9D9), height: 1,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp ${item["pesanan"].fold(0, (sum, menu) => sum + (menu["jumlah"] * menu["harga"])).toString()}",
                              style: TextStyle(color: Color(0xFF403E3E), fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${item["pesanan"].fold(0, (sum, menu) => sum + menu["jumlah"]).toString()} Menu",
                              style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => DetailPesananView(), arguments: item);
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF19345E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), 
                            ),
                          ),
                          child: Text(
                            "Lihat Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ));
    }
    return Expanded(
      child: PageTransitionSwitcher(
        duration: Duration(milliseconds: 1000), 
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal, 
            child: child,
          );
        },
        child: TabBarView(
          key: ValueKey(controller.tabController.index),
          controller: controller.tabController,
          children: [
            buildListView(controller.pesananMasuk), 
            buildListView(controller.pesananDimasak), 
          ],
        ),
      ),
    );
  }
}
