import 'package:dikantin/app/modules/profile/controllers/profile_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/unit_model.dart';
import '../../order/controllers/order_controller.dart';
import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  MapsView({
    Key? key,
    required this.selectedBuilding,
    required this.keterangan,
    required this.initialSelectedValue,
  }) : super(key: key) {
    controllerMaps.selectedBuilding = selectedBuilding;
    controllerMaps.keteranganController.text = keterangan;
  }
  final MapsController controllerMaps = Get.put(MapsController());
  final ProfileController profilC = Get.find<ProfileController>();
  final OrderController orderC = Get.find<OrderController>();
  final String selectedBuilding;
  final String keterangan;
  final String initialSelectedValue;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pilih Lokasi'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Obx(
                  () => GoogleMap(
                    onMapCreated: (controller) {
                      controllerMaps.mapController = controller;
                      controllerMaps.addPolygon();
                    },
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(-8.15794, 113.72380),
                      zoom: 18.0,
                    ),
                    markers: Set<Marker>.from(controllerMaps.markers.toList()),
                    polygons: controllerMaps.polygons,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      onPressed: () async {
                        await controllerMaps.determinePosition();
                        await controllerMaps.getCurrentLocation();
                      },
                      icon: const Icon(
                        Icons.my_location,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 60,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      onPressed: () async {
                        controllerMaps.goToKampus();
                        //orderC.getUnit();
                      },
                      icon: const Icon(
                        Icons.school_rounded,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => DropdownSearch<String>(
                      popupProps: PopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: orderC.unit.value.data
                              ?.map((data) => data?.namaGedung ?? "")
                              .toList() ??
                          [],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pilih Gedung",
                          hintText: "Pilih gedung dari daftar",
                        ),
                      ),
                      onChanged: (String? selectedValue) {
                        if (selectedValue != null) {
                          // Dapatkan data gedung yang sesuai dari sumber daya data
                          var selectedData = orderC.unit.value.data?.firstWhere(
                            (data) => data?.namaGedung == selectedValue,
                          );

                          // Cetak latitude dan longitude jika data ditemukan
                          if (selectedData is Data) {
                            print(
                              'Latitude: ${selectedData.lattitude}, Longitude: ${selectedData.longtitude}',
                            );

                            controllerMaps.placeMarker(
                              double.parse(selectedData.lattitude.toString()),
                              double.parse(selectedData.longtitude.toString()),
                            );
                            controllerMaps.selectedBuilding = selectedValue;
                            controllerMaps.selectedLatitude =
                                double.parse(selectedData.lattitude.toString());
                            controllerMaps.selectedLongitude = double.parse(
                                selectedData.longtitude.toString());
                          } else {
                            print('Data not found');
                          }
                        }
                      },
                      selectedItem: orderC.unit.value.data?.isNotEmpty == true
                          ? profilC.profile.value.data?.alamat != ''
                              ? profilC.profile.value.data?.alamat
                              : orderC.unit.value.data!.first?.namaGedung
                          : 'pilih Gedung',
                    ),
                  ),
                  TextField(
                    controller: controllerMaps.keteranganController
                      ..text = profilC.profile.value.data?.ket ?? "",
                    decoration: InputDecoration(
                        labelText: 'Keterangan',
                        hintText: "Cth: Taruh di satpam"),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Pengecekan apakah keterangan tidak diisi
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      if (controllerMaps.keteranganController.text.isEmpty) {
                        EasyLoading.dismiss();
                        print('EasyLoading dismiss');
                        Get.snackbar(
                          'Peringatan',
                          'Mohon isi keterangan',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        // Mendapatkan koordinat marker dari TextField
                        double markerLatitude = double.parse(
                            controllerMaps.latitudeController.text);
                        double markerLongitude = double.parse(
                            controllerMaps.longitudeController.text);

                        // Pengecekan apakah marker berada di dalam kampus
                        bool insideCampus = controllerMaps.isInsideCampus(
                            LatLng(markerLatitude, markerLongitude));

                        if (insideCampus) {
                          profilC.editAlamat(
                              alamat: controllerMaps
                                  .selectedBuilding, // Gunakan nama gedung
                              lat: controllerMaps.selectedLatitude
                                  .toString(), // Gunakan latitude
                              long: controllerMaps.selectedLongitude
                                  .toString(), // Gunakan longitude
                              ket: controllerMaps.keteranganController.text);
                          EasyLoading.dismiss();
                          print('EasyLoading dismiss');
                          Get.back();

                          // Gunakan keterangan
                        } else {
                          // Jika di luar kampus, tampilkan snackbar
                          EasyLoading.dismiss();
                          print('EasyLoading dismiss');
                          Get.snackbar(
                            'Gagal Menyimpan',
                            'Lokasi diluar kampus, Mohon atur lokasi didalam kampus',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
