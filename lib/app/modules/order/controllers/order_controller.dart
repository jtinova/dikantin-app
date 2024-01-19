import 'package:dikantin/app/data/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/qr_model.dart';
import '../../../data/models/unit_model.dart';
import '../../../data/providers/profile_provider.dart';

class OrderController extends GetxController {
  var locationMessage = "Belum mendapatkan Lat dan Long".obs;
  var addressMessage = "".obs;
  var textEditingController = TextEditingController().obs;
  final ProfileProvider provider = ProfileProvider().obs();
  final _customerProvider = CustomerProvider().obs;
  Rx<Profile> profile = Profile().obs;
  Rx<Unit> unit = Unit().obs;
  var addressController = TextEditingController();
  RxBool isButtonEnabled = true.obs;
  RxBool isImageUploading = false.obs;
  RxBool isLoading = true.obs;
  Rx<Qr> qrData = Qr().obs;

  var myPosition = Position(
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0.0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  ).obs;
  @override
  void onInit() {
    super.onInit();
    getCustomerData();
    getUnit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service belum aktif");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied)
        return Future.error("Location Permission ditolak");
    }

    if (locationPermission == LocationPermission.deniedForever)
      return Future.error(
          "Location permission ditolak, gagal request permissions");

    Position position = await Geolocator.getCurrentPosition();
    myPosition.value = position;
  }

  Future<void> getAddressFromLatLong(Position position) async {
    print('Latitude: ${position.latitude}');
    print('Longitude: ${position.longitude}');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    addressMessage.value =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
  }

  Future<void> getCustomerData() async {
    try {
      isLoading(true);

      // Call the getCustomer method from CustomerProvider
      Profile result = await _customerProvider.value.fetchDatacus();

      // Update the customer data
      profile(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching dataprofile: $error');
    }
  }

  Future<void> getUnit() async {
    try {
      isLoading(true);

      // Call the getCustomer method from CustomerProvider
      Unit result = await _customerProvider.value.getDataUnit();

      // Update the customer data
      unit(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching dataprofile: $error');
    }
  }

  Future<void> fetchQr() async {
    try {
      isLoading(true);

      // Call the fetchqr method from CustomerProvider
      Qr result = await _customerProvider.value.fetchqr();

      // Update the qr data
      qrData(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching QR data: $error');
    }
  }

  Future<void> editAlamat(
      {required String alamat,
      required String lat,
      required String long,
      required String ket}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        await provider.editAlamat(
            token: token, alamat: alamat, long: long, lat: lat, ket: ket);
        await getCustomerData();
      } catch (error) {
        // Handle and print the error
        print('Error updating profile: $error');
      }
    } else {
      // Handle case where token is not available (e.g., user not logged in)
      print('Token not available. User not logged in.');
    }
  }

  Future<void> getAccurateLocation() async {
    try {
      isLoading(true);

      // Mendapatkan lokasi terkini dengan akurasi terbaik
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Check if the location is mocked
      if (position.isMocked) {
        isLoading(false);
        Get.snackbar(
          'Error',
          'Fake location detected',
          backgroundColor: Colors.red,
        );
        return;
      }

      // Menyimpan lokasi terkini
      myPosition.value = position;

      // Mendapatkan alamat dari lokasi terkini

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching location: $error');
    }
  }
}
