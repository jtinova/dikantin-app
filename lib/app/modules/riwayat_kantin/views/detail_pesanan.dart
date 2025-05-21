import 'package:dikantin_app_rebuild/app/models/history_canteen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayatkantin_controller.dart';

class DetailPesananView extends GetView<RiwayatKantinController> {
  DetailPesananView({super.key});

  @override
  final RiwayatKantinController controller = Get.put(RiwayatKantinController());

  @override
  Widget build(BuildContext context) {
    final HistoryModel data = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color(0xFF19345E),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              iconSize: 15,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
        ),
        title: Text(
          "Rincian Pesanan",
          style: TextStyle(
              color: Color(0xFF403E3E),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Pesanan(item: data),
            ListPesanan(item: data),
          ],
        )
      ),
    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key, required this.item});

  final HistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.transactionCode,
                  style: TextStyle(
                      color: Color(0xFF403E3E),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  item.customerName,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 14),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Status: ${item.statusLabel}",
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 14),
                ),
                Text(
                  item.date,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ListPesanan extends StatelessWidget {
  const ListPesanan({super.key, required this.item});

  final HistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pesanan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: item.menu.length,
              itemBuilder: (context, index) {
                var pesanan = item.menu[index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              pesanan.imagePath,
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
                                  pesanan.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF403E3E),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rp ${pesanan.mainCost}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF403E3E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "X ${pesanan.qty}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF403E3E),
                                        fontWeight: FontWeight.w600,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Divider(color: Color(0xFFD9D9D9), height: 1),
                    ),
                  ],
                );
              }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Modal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Rp ${item.totalMainCost}",
                  style: TextStyle(
                      color: Color(0xFF403E3E),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
