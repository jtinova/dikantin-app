import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayatkantin_controller.dart';


class RiwayatKantinView extends GetView<RiwayatKantinController> {
  RiwayatKantinView({super.key});

  @override
  final RiwayatKantinController controller = Get.put(RiwayatKantinController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Riwayat Pesanan",
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
          children: [
            Saldo(),
            Filter(),
            RiwayatPesanan(),
          ],
        )
      ),
    );
  }
}

class Saldo extends StatelessWidget {
  const Saldo({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatKantinController controller = Get.find<RiwayatKantinController>();

    return Container(
      margin: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF19345E),
        borderRadius: BorderRadius.circular(12)
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              "Total Pendapatan",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "Rp ${controller.totalPendapatan}",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatKantinController controller = Get.find<RiwayatKantinController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton(
              onSelected: (value) {
                controller.selectedItem.value = value; 
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "Semua", child: Text("Semua")),
                PopupMenuItem(value: "Selesai", child: Text("Selesai")),
                PopupMenuItem(value: "Dibatalkan", child: Text("Dibatalkan")),
              ],
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      controller.selectedItem.value,
                      style: TextStyle(
                        color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.w500),
                    )),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  controller.selectedDate.value =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      controller.selectedDate.value.isNotEmpty
                          ? controller.selectedDate.value
                          : "Pilih Tanggal",
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan ({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatKantinController controller = Get.find<RiwayatKantinController>();

    Widget buildListView(RxList<Map<String, dynamic>> data) {
      return Obx(() => ListView.builder(
        padding: EdgeInsets.all(14),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var controller = data[index];
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
                          controller["image"]!,
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
                              controller["id"]!,
                              style: TextStyle(color: Color(0xFF403E3E), fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  controller["datetime"]!,
                                  style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13,), 
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.circle, size: 5, color: Color(0xFF7C7C7C),),
                                ),
                                Text(
                                  controller["status"]!,
                                  style: TextStyle(
                                    color: controller["status"] == "Selesai" ? Colors.green : Colors.red,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              (controller["pesanan"] as List<dynamic>)
                                  .map((menu) => "${menu["jumlah"]} ${menu["nama"]}")
                                  .join(", "),
                              style: TextStyle(color: Color(0xFF585858), fontSize: 15),
                            ),
                          ],
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
                              "Rp ${controller["pesanan"].fold(0, (sum, menu) => sum + (menu["jumlah"] * menu["harga"])).toString()}",
                              style: TextStyle(color: Color(0xFF403E3E), fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${controller["pesanan"].fold(0, (sum, menu) => sum + menu["jumlah"]).toString()} Menu",
                              style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            
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
      child: buildListView(controller.riwayatPesanan),
    );
  }
}