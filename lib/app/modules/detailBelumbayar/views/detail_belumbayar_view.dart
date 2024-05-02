import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pengantarfrontend/app/modules/done/views/done_view.dart';
import 'package:pengantarfrontend/app/modules/mapsviewer/views/dashline.dart';
import '../controllers/mapsviewer_controller.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';

class MapsviewerView extends GetView<MapsviewerController> {
  MapsviewerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: DraggableBottomSheet(
            barrierDismissible: true,
            minExtent: 200,
            useSafeArea: true,
            curve: Curves.easeIn,
            previewWidget: _previewWidget(context),
            expandedWidget: _expandedWidget(context),
            backgroundWidget: _backgroundWidget(context),
            maxExtent: MediaQuery.of(context).size.height * 0.84,
            onDragging: (pos) {},
          ),
        );
      }),
    );
  }

  Widget _backgroundWidget(BuildContext context) {
    final accessToken = controller.getAccessToken();
    final initialLatitude = controller.getInitialLatitude();
    final initialLongitude = controller.getInitialLongitude();
    final initialBoundSW = controller.getInitialBoundSW();
    final initialBoundNE = controller.getInitialBoundNE();
    return Scaffold(
      body: Center(
        child: Container(
          child: MapboxMap(
            accessToken: accessToken,
            initialCameraPosition: CameraPosition(
              target: LatLng(initialLatitude, initialLongitude),
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            minMaxZoomPreference: const MinMaxZoomPreference(10, 18),
          ),
        ),
      ),
    );
  }

  Widget _previewWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.5, // Meningkatkan nilai maxHeight
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: SizedBox(
              width: 60,
              child: InkWell(
                onTap: () {
                  _expandedWidget(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFFBEBEBE),
                  ),
                  height: 6,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Container(
              child: Row(
                children: [
                  Text(
                    "Pesanan Untuk Diantar ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                left: 30,
                top: 42,
                bottom: 42,
                child: DashedLineDivider(
                  height: 1,
                  color: Colors.black,
                  dashLength: 4,
                  dashGap: 3,
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      "assets/icon/time.png",
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      'Kantin Sehat FKG | Gedung FKG',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'BeVietnamPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitleTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    subtitle: Text(
                      'Lokasi Kantin | Perkiraan kamu sampai: 13.43 WIB',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'BeVietnamPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(90, 30),
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {
                        Get.to(DoneView());
                      },
                      child: Text(
                        "Diambil",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      "assets/icon/maps.png",
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      'Mala Komalasari | Gedung A',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'BeVietnamPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitleTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    subtitle: Text(
                      'Konsumen | Perkiraan kamu sampai: 13.47 WIB',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'BeVietnamPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expandedWidget(BuildContext context) {
    List categories = [
      {
        "name": "Nasi Katsu",
        "qty": "2x",
        "price": "Rp 35.000",
        "image": "assets/nasi_katsu.jpeg"
      },
      {
        "name": "Es pisang ijo",
        "qty": "1x",
        "price": "Rp 12.500",
        "image": "assets/espisangijo.png"
      },
      {
        "name": "Es teh manis",
        "qty": "1x",
        "price": "Rp 7.500",
        "image": "assets/esteh.png"
      },
    ];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
     
         
    );
  }
}

