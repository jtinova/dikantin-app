import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pesanan_controller.dart';
import 'package:animations/animations.dart';
import 'detail_pesanan.dart';
import 'package:dikantin_app_rebuild/app/models/order_canteen.dart';


class PesananKantinView extends GetView<PesananController> {
  PesananKantinView({super.key});

  @override
  final PesananController controller = Get.put(PesananController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF19345E),
        elevation: 0,
        title: Text(
          "Pesanan",
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
                      "• Tekan tab 'Pesanan Masuk' untuk melihat daftar pesanan baru.\n"
                      "• Tekan tab 'Dimasak' untuk melihat daftar pesanan dimasak.\n"
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
        child: Container(
          color: Color(0xFFFEFEFE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Expanded(child: Pesanan()),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final PesananController controller = Get.find<PesananController>();

    return Container(
      color: Color(0xFFFEFEFE),
      child: TabBar(
        padding: EdgeInsets.symmetric(vertical: 8),
        controller: controller.tabController,
        isScrollable: false,
        labelColor: Color(0xFF19345E),
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: Color(0xFF19345E),
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(text: "Pesanan Masuk"),
          Tab(text: "Dimasak"),
        ],
      ),
    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final PesananController controller = Get.find<PesananController>();

    Widget buildListView(RxList<TransactionModel> data) {
      return Obx(() => RefreshIndicator(
        onRefresh: () async {
            controller.refreshData();
          },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
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
                            item.details.first.imagePath,
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
                                    item.dateTime,
                                    style: TextStyle(
                                      color: Color(0xFF7C7C7C),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                item.details
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
                                "Rp ${item.mainCost}",
                                style: TextStyle(
                                    color: Color(0xFF403E3E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${item.totalQty} Pesanan",
                                style: TextStyle(
                                    color: Color(0xFF7C7C7C), fontSize: 13),
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