import 'package:dikantin_app_rebuild/app/models/history_canteen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayatkantin_controller.dart';
import '../views/detail_pesanan.dart';


class RiwayatKantinView extends GetView<RiwayatKantinController> {
  RiwayatKantinView({super.key});

  @override
  final RiwayatKantinController controller = Get.put(RiwayatKantinController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF19345E),
        elevation: 0,
        title: Text(
          "Riwayat Pesanan",
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
                      "• Tekan tombol 'Lihat Detail' untuk melihat detail dari pesanan.\n",
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
        child: Column(
          children: [
            // Saldo(),
            // Filter(),
            RiwayatPesanan(),
          ],
        )
      ),
    );
  }
}


class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan ({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatKantinController controller = Get.find<RiwayatKantinController>();

    Widget buildListView(RxList<HistoryModel> data) {
      return Obx(() => RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: ListView.builder(
              padding: EdgeInsets.all(14),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.menu.first.imagePath,
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
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.transactionCode,
                                    style: TextStyle(
                                        color: Color(0xFF403E3E),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        item.date,
                                        style: TextStyle(
                                          color: Color(0xFF7C7C7C),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item.menu
                                        .map((menu) =>
                                            "${menu.qty} ${menu.name}")
                                        .join(", "),
                                    style: TextStyle(
                                        color: Color(0xFF585858), fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                            color: Color(0xFFD9D9D9),
                            height: 1,
                          ),
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
                                    "Rp ${item.totalMainCost}",
                                    style: TextStyle(
                                        color: Color(0xFF403E3E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Pembayaran: ${item.paymentMethodLabel}",
                                    style: TextStyle(
                                        color: Color(0xFF7C7C7C), fontSize: 14),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => DetailPesananView(),
                                      arguments: item);
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
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      ));
    }
    return Expanded(
      child: buildListView(controller.daftarMenu),
    );
  }
}

// class Filter extends StatelessWidget {
//   const Filter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final RiwayatKantinController controller = Get.find<RiwayatKantinController>();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: PopupMenuButton(
//               onSelected: (value) {
//                 controller.selectedItem.value = value; 
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(value: "Semua", child: Text("Semua")),
//                 PopupMenuItem(value: "Selesai", child: Text("Selesai")),
//                 PopupMenuItem(value: "Dibatalkan", child: Text("Dibatalkan")),
//               ],
//               child: Container(
//                 padding: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey, width: 1),
//                   borderRadius: BorderRadius.circular(6)
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Obx(() => Text(
//                       controller.selectedItem.value,
//                       style: TextStyle(
//                         color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.w500),
//                     )),
//                     Icon(Icons.arrow_drop_down, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10,),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );

//                 if (pickedDate != null) {
//                   controller.selectedDate.value =
//                       "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey, width: 1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Obx(() => Text(
//                       controller.selectedDate.value.isNotEmpty
//                           ? controller.selectedDate.value
//                           : "Pilih Tanggal",
//                       style: TextStyle(
//                         color: Color(0xFF6B7280),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )),
//                     Icon(Icons.calendar_today, color: Colors.grey, size: 20),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }