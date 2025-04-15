import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/button_merge.dart';

class DetailPesananView extends GetView<HomeController> {
  DetailPesananView({super.key});

  final ButtonController button = Get.put(ButtonController());

  @override
  final HomeController controller = Get.put(HomeController());

@override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF19345E),
            borderRadius: BorderRadius.circular(10)
          ),
          child: IconButton(
            iconSize: 15,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined, 
              color: Colors.white,)
          ),
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
            Pesanan(item: item),
            ListPesanan(item: item),
            Catatan(item: item,)
          ],
        )
      ),
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.only(bottom: 20),
  child: BottomAppBar(
    elevation: 0,
    color: Colors.transparent,
    child: GestureDetector(
      onTap: () {
        
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF19345E),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          "Masak",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  ),
),

    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key, required this.item});

  final Map<String, dynamic> item;

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
                  "Dikantin",
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 14, fontWeight: FontWeight.w500),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item["id"]!,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  item["datetime"]!,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 13),
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

  final Map<String, dynamic> item;

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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(),
              itemCount: item["pesanan"].length,
              itemBuilder: (context, index) {
                var pesanan = item["pesanan"][index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8), 
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item["image"]!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10), 
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pesanan["nama"],
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
                                      "Rp ${pesanan["harga"]}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF403E3E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${pesanan["jumlah"]}",
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
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "Rp ${item["pesanan"].fold(0, (sum, menu) => sum + (menu["jumlah"] * menu["harga"])).toString()}",
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Catatan extends StatelessWidget {
  const Catatan({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: Card(       
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catatan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 6),
              Text(
                item["catatan"]!,
                style: TextStyle(color: Color(0xFF403E3E), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}