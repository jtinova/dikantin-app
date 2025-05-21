// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/home_kantin_controller.dart';

// class HomeKantinView extends GetView<HomeKantinController> {
//   HomeKantinView({super.key});

//   @override
//   final HomeKantinController controller = Get.put(HomeKantinController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFEFEFE),
//         elevation: 0,
//         toolbarHeight: 0,
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Color(0xFFFEFEFE),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Header(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Riwayat",
//                       style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Lihat semua",
//                           style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_right_alt_rounded, 
//                           color: Color(0xFF1E2857), 
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               RiwayatPesanan(),
//             ],
//           ),
//         ) 
//       ),
//     );
//   }
// }

// class Header extends StatelessWidget {
//   const Header({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeKantinController controller = Get.find<HomeKantinController>();
    
//     return Container(
//       height: 450,
//       width: double.infinity,
//       alignment: Alignment.centerLeft,
//       color: Color(0xFF1E2857),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 34, bottom: 14),
//         child: Column(
//           children: [
//             Text(
//               "Kantin Emak",
//               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               width: 180, 
//               decoration: BoxDecoration(
//                 color: Color(0xFFdee8fb),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: EdgeInsets.all(4),
//               child: Obx(() => Row(
//                 children: [ 
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         controller.selectedItem.value = 'Buka';
//                         Get.snackbar(
//                           "Status Kantin", 
//                           "Status diubah ke Buka", 
//                           snackPosition: SnackPosition.TOP, 
//                           backgroundColor: Colors.white,
//                           colorText: Colors.black,
//                           margin: EdgeInsets.all(10),
//                           borderRadius: 10,
//                           duration: Duration(seconds: 2),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: controller.selectedItem.value == 'Buka'
//                               ? Color(0xFF1E2857)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         alignment: Alignment.center, 
//                         padding: EdgeInsets.symmetric(vertical: 8), 
//                         child: Text(
//                           'Buka',
//                           style: TextStyle(
//                             color: controller.selectedItem.value == 'Buka'
//                                 ? Colors.white
//                                 : Color(0xFF1E2857),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         controller.selectedItem.value = 'Tutup';
//                         Get.snackbar(
//                           "Status Kantin",
//                           "Status diubah ke Tutup",
//                           snackPosition: SnackPosition.TOP,
//                           backgroundColor: Colors.white,
//                           colorText: Colors.black,
//                           margin: EdgeInsets.all(10),
//                           borderRadius: 10,
//                           duration: Duration(seconds: 2),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: controller.selectedItem.value == 'Tutup'
//                               ? Color(0xFF1E2857)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         alignment: Alignment.center, 
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                         child: Text(
//                           'Tutup',
//                           style: TextStyle(
//                             color: controller.selectedItem.value == 'Tutup'
//                                 ? Colors.white
//                                 : Color(0xFF1E2857),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//             ),
        
//             // Container(
//             //   margin: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
//             //   decoration: BoxDecoration(
//             //     color: Color(0xFFf0f5fe),
//             //     borderRadius: BorderRadius.circular(30)
//             //   ),
//             //   width: double.infinity,
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(vertical: 17),
//             //     child: Column(
//             //       children: [
//             //         Text(
//             //           "Pendapatan hari ini",
//             //           style: TextStyle(color: Colors.black, fontSize: 16),
//             //         ),
//             //         SizedBox(height: 6),
//             //         Text(
//             //           "Rp 10.000",
//             //           style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // )
//             SizedBox(height: 40),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: Text(
//                     "Pendapatan",
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             "Hari ini",
//                             style: TextStyle(color: Colors.grey[50], fontSize: 15),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Rp 23.000",
//                             style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       )
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             "Bulan ini",
//                             style: TextStyle(color: Colors.grey[50], fontSize: 15),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Rp 1.345.000",
//                             style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       )
//                     )
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 20),
//                   child: Text(
//                     "Transaksi",
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: Color(0xFFdee8fb),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.shopping_cart_rounded, 
//                                 color: Color(0xFF1E2857), 
//                                 size: 42,
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     "Dilayani",
//                                     style: TextStyle(color: Colors.black, fontSize: 15),
//                                   ),
//                                   SizedBox(height: 3),
//                                   Text(
//                                     "4",
//                                     style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ),
//                       ),
//                       SizedBox(width: 20),
//                       Expanded(
//                         child: Container(
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: Color(0xFFdee8fb),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.assignment_turned_in_sharp, 
//                                 color: Color(0xFF1E2857), 
//                                 size: 42,
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     "Selesai",
//                                     style: TextStyle(color: Colors.black, fontSize: 15),
//                                   ),
//                                   SizedBox(height: 3),
                                  
//                                   Text(
//                                     "10",
//                                     style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             )
            
//           ],
//         ),
//       ),
//     );
//   }
// }


// class RiwayatPesanan extends StatelessWidget {
//   const RiwayatPesanan ({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeKantinController controller = Get.find<HomeKantinController>();

//     Widget buildListView(RxList<Map<String, dynamic>> data) {
//       return Obx(() => ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           var controller = data[index];
//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           controller["image"]!,
//                           width: 70,
//                           height: 70,
//                           fit: BoxFit.cover,
//                         )
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               controller["id"]!,
//                               style: TextStyle(color: Color(0xFF403E3E), fontSize: 16, fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 Text(
//                                   controller["datetime"]!,
//                                   style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13,), 
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                                   child: Icon(Icons.circle, size: 5, color: Color(0xFF7C7C7C),),
//                                 ),
//                                 Text(
//                                   controller["status"]!,
//                                   style: TextStyle(
//                                     color: controller["status"] == "Selesai" ? Colors.green : Colors.red,
//                                     fontSize: 13,
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               (controller["pesanan"] as List<dynamic>)
//                                   .map((menu) => "${menu["jumlah"]} ${menu["nama"]}")
//                                   .join(", "),
//                               style: TextStyle(color: Color(0xFF585858), fontSize: 15),
//                             ),
//                           ],
//                         )
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     child: Divider(color: Color(0xFFD9D9D9), height: 1,),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Rp ${controller["pesanan"].fold(0, (sum, menu) => sum + (menu["jumlah"] * menu["harga"])).toString()}",
//                               style: TextStyle(color: Color(0xFF403E3E), fontSize: 15, fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "${controller["pesanan"].fold(0, (sum, menu) => sum + menu["jumlah"]).toString()} Menu",
//                               style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 13),
//                             ),
//                           ],
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
                            
//                           }, 
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF19345E),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20), 
//                             ),
//                           ),
//                           child: Text(
//                             "Lihat Detail",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500
//                             ),
//                           )
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//       ));
//     }
//     return Expanded(
//       child: buildListView(controller.riwayatPesanan),
//     );
//   }
// }