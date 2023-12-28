// ignore_for_file: prefer_const_constructors

import 'package:dikantin/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:dikantin/app/modules/utils/minuman.dart';
import 'package:dikantin/app/modules/utils/favorite.dart';
import 'package:dikantin/app/modules/utils/makanan.dart';
import 'package:dikantin/app/modules/utils/semua.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final HomeController c = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final app = AppBar(
      elevation: 0, // Menghilangkan shadow di bawah AppBar
      backgroundColor: Colors.white, // Membuat AppBar transparan
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: IconButton.filledTonal(
            onPressed: () {
              Get.toNamed('/keranjang');
            },
            icon: Obx(
              () => badges.Badge(
                badgeAnimation: badges.BadgeAnimation.slide(),
                badgeContent: Text(
                  c.countc.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -10, end: -10),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Color(0xFF00C2FF),
                ),
              ),
            ),
          ),
        ),
      ],
      title: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
        child: Image.asset(
          'assets/logo_dikantin.png',
          height: 90, // Sesuaikan dengan tinggi yang Anda inginkan
          width: 90, // Sesuaikan dengan lebar yang Anda inginkan
          fit: BoxFit.cover,
        ),
      ),
    );
    final mediaBody = mediaHeight -
        app.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: app,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: NestedScrollView(
                  headerSliverBuilder: (context, isScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 120.0,
                        // collapsedHeight: 100,
                        floating: false,
                        pinned: false,
                        flexibleSpace: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Container(
                            height: mediaBody * 0.20,
                            padding: EdgeInsets.fromLTRB(20, 30, 10, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Saldo Polije Pay ",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mediaBody * 0.02,
                                    ),
                                    Container(
                                      height: 22,
                                      // width: 64,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF00C2FF),
                                              width: 1.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              c.ngapek();
                                            },
                                            child: Container(
                                              child: Text(
                                                "Top Up",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Color(0xFF00C2FF),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                              child: Icon(
                                            Icons.add_circle_rounded,
                                            size: 15,
                                            color: Color(0xFF00C2FF),
                                          )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: mediaBody / 400,
                                ),
                                Container(
                                  // padding: EdgeInsets.only(right: x * 0.25),
                                  child: Text(
                                    "Rp. 0",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: MyTabBarDelegate(
                          TabBar(
                            controller: controller.tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            isScrollable: true,
                            indicator:
                                DotTabIndicator(color: Color(0xFF00C2FF)),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Favorit",
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Semua",
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Makanan",
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Minuman",
                                ),
                              ),
                            ],
                            labelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight
                                    .bold, // Font Weight untuk yang terpilih
                              ),
                            ),
                            unselectedLabelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight
                                    .normal, // Font Weight untuk yang tidak terpilih
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                      controller: controller.tabController,
                      children: [Favorite(), Semua(), Makanan(), Minuman()]),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(
                      () => AnimatedOpacity(
                        duration: Duration(
                            milliseconds:
                                500), // Sesuaikan durasi fade in dan fade out
                        opacity: controller.countc > 0 ? 1.0 : 0.0,
                        child: Visibility(
                          visible: controller.countc > 0,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed('/keranjang');
                              print(textScaleFactor);
                            },
                            child: Container(
                              //ini container info
                              height: mediaHeight *
                                  0.07, // Use a percentage of the screen height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF2579FD),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.countc.toString()} item",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: mediaWidth * 0.5,
                                                child: Text(
                                                  "Siap mengantar pesanan ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines:
                                                      1, // Set a maximum number of lines

                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Text(
                                                controller.totalPrice
                                                    .toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.shopping_cart,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  MyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.blue,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFFEDFBFF), Color(0xFFE7F8FD)]\,
          // ),
          color: Colors.white,
        ),
        child: _tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class DotTabIndicator extends Decoration {
  final double indicatorRadius;
  final Color color;

  DotTabIndicator({
    this.indicatorRadius = 4,
    this.color = Colors.blue,
  });

  @override
  _DotPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(this, onChanged!);
  }
}

class _DotPainter extends BoxPainter {
  final DotTabIndicator decoration;

  _DotPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = Offset(
          offset.dx +
              (configuration.size!.width / 2) -
              decoration.indicatorRadius,
          offset.dy +
              configuration.size!.height -
              decoration.indicatorRadius * 3,
        ) &
        Size(
          decoration.indicatorRadius * 2,
          decoration.indicatorRadius * 2,
        );

    final Paint paint = Paint();
    paint.color = decoration.color;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(rect.center, decoration.indicatorRadius, paint);
  }
}
