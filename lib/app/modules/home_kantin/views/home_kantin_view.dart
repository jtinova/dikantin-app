import 'package:dikantin_app_rebuild/app/modules/riwayat_kantin/views/riwayatkantin_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_kantin_controller.dart';
import 'package:dikantin_app_rebuild/app/models/history_canteen.dart';

class HomeKantinView extends GetView<HomeKantinController> {
  HomeKantinView({super.key});

  @override
  final HomeKantinController controller = Get.put(HomeKantinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.refreshData();
          },
          child: Container(
            color: Color(0xFFFEFEFE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Riwayat",
                //         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                //       ),
                //       Row(
                //         children: [
                //           Text(
                //             "Lihat semua",
                //             style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                //           ),
                //           SizedBox(width: 4),
                //           Icon(
                //             Icons.arrow_right_alt_rounded, 
                //             color: Color(0xFF1E2857), 
                //             size: 16,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
               
              ],
            ),
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
    final HomeKantinController controller = Get.find<HomeKantinController>();
    
    return Expanded(
      child: Stack(
       
        children: [ Container(
          height: 420,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          color: Color(0xFF1E2857),
          child: Padding(
            padding: const EdgeInsets.only(top: 34, bottom: 14),
            child: Column(
              children: [
                Obx(() => Text(
                  controller.canteenName.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                SizedBox(height: 16),
                Container(
                  width: 180, 
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f8fa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Obx(() => Row(
                    children: [ 
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedItem.value = 'Buka';
                            controller.updateCanteenStatus('open');
                            Get.snackbar(
                              "Status Kantin", 
                              "Status diubah ke Buka", 
                              snackPosition: SnackPosition.TOP, 
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              margin: EdgeInsets.all(10),
                              borderRadius: 10,
                              duration: Duration(seconds: 2),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedItem.value == 'Buka'
                                  ? Color(0xFF1E2857)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center, 
                            padding: EdgeInsets.symmetric(vertical: 8), 
                            child: Text(
                              'Buka',
                              style: TextStyle(
                                color: controller.selectedItem.value == 'Buka'
                                    ? Colors.white
                                    : Color(0xFF1E2857),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedItem.value = 'Tutup';
                            controller.updateCanteenStatus('close');
                            Get.snackbar(
                              "Status Kantin",
                              "Status diubah ke Tutup",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              margin: EdgeInsets.all(10),
                              borderRadius: 10,
                              duration: Duration(seconds: 2),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedItem.value == 'Tutup'
                                  ? Color(0xFF1E2857)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center, 
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Tutup',
                              style: TextStyle(
                                color: controller.selectedItem.value == 'Tutup'
                                    ? Colors.white
                                    : Color(0xFF1E2857),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
            
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                //   decoration: BoxDecoration(
                //     color: Color(0xFFf0f5fe),
                //     borderRadius: BorderRadius.circular(30)
                //   ),
                //   width: double.infinity,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 17),
                //     child: Column(
                //       children: [
                //         Text(
                //           "Pendapatan hari ini",
                //           style: TextStyle(color: Colors.black, fontSize: 16),
                //         ),
                //         SizedBox(height: 6),
                //         Text(
                //           "Rp 10.000",
                //           style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
                SizedBox(height: 26),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pendapatan",
                      style: TextStyle(color: Color(0xFFeaeaea), fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Hari ini",
                                style: TextStyle(color: Color(0xFFeaeaea), fontSize: 15, fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 3),
                              Obx(() => Text(
                                "Rp ${controller.totalIncomeToday.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                            ],
                          )
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Bulan ini",
                                style: TextStyle(color: Color(0xFFeaeaea), fontSize: 15, fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 3),
                              Obx(() => Text(
                                "Rp ${controller.totalIncomeMonth.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                            ],
                          )
                        )
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, top: 20),
                    //   child: Text(
                    //     "Transaksi",
                    //     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xFFf4f8fa),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_rounded, 
                                    color: Color(0xFF1E2857), 
                                    size: 42,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Dilayani",
                                        style: TextStyle(color: Color(0xFF1E2857), fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3),
                                      Obx(() => Text(
                                        "${controller.totalOrderServed.value}",
                                        style: const TextStyle(
                                          color: Color(0xFF1E2857),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xFFf4f8fa),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.assignment_turned_in_sharp, 
                                    color: Color(0xFF1E2857), 
                                    size: 42,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Selesai",
                                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3),
                                      Obx(() => Text(
                                        "${controller.totalOrderDone.value}",
                                        style: const TextStyle(
                                          color: Color(0xFF1E2857),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                
              ],
            ),
          ),
        ),
        Positioned(
          top: 370,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            height: 250, 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => RiwayatKantinView()); 
                      //   },
                      //   child: Text(
                      //     'Lihat Semua',
                      //     style: TextStyle(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w500,
                      //       color: Color(0xFF263982),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(child: RiwayatPesanan()),
              ],
            ),
          ),
        )
      ]),
    )
    ;
  }
}


class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan ({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeKantinController controller = Get.find<HomeKantinController>();

    Widget buildListView(RxList<HistoryModel> data) {
      return Obx(() => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(14),
            itemCount: data.length >= 2 ? 2 : data.length,
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
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Get.to(() => DetailPesananView(),
                            //         arguments: item);
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Color(0xFF19345E),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //   ),
                            //   child: Text(
                            //     "Lihat Detail",
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ));
    }
    return Expanded(
      child: buildListView(controller.daftarMenu),
    );
  }
}