import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  final count = 0.obs;
  GoogleMapController?
      mapController; // Gunakan nullable untuk menghindari LateInitializationError
  RxSet<Marker> markers = <Marker>{}.obs;
  var addressMessage = "".obs;
  Set<Polygon> polygons = {}; // Menyimpan poligon area kampus
  String selectedBuilding = '';
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  StreamSubscription<Position>? _positionStreamSubscription;

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
    _positionStreamSubscription?.cancel();
    addPolygon();
    determinePosition();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> startLocationStreaming() async {
    try {
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10, // set the distance filter as needed
        ),
      ).listen((Position position) {
        updateLocation(position);
      });
    } catch (e) {
      print("Error streaming location: $e");
    }
  }

  void updateLocation(Position position) {
    // Handling lokasi yang valid
    if (position.latitude != 0.0 && position.longitude != 0.0) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17.0,
          ),
        ),
      );

      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Lokasi Saat Ini'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );

      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
      getAddressFromLatLng(position.latitude, position.longitude);
    } else {
      // Handle jika lokasi tidak valid
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi yang valid',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool isInsideCampus(LatLng point) {
    for (Polygon polygon in polygons) {
      if (_pointInPolygon(point, polygon.points)) {
        return true;
      }
    }
    return false;
  }

  void placeMarker(double latitude, double longitude) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17.0,
        ),
      ),
    );

    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('selected_location'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: 'Lokasi Gedung Dipilih'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    latitudeController.text = latitude.toString();
    longitudeController.text = longitude.toString();
    getAddressFromLatLng(latitude, longitude);
  }

  Future<void> getAddressFromLatLng(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      addressMessage.value =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
    } else {
      addressMessage.value = "alamat tidak ditemukan";
    }
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      if (_rayCastIntersect(point, polygon[j], polygon[j + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  bool _rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double pY = point.latitude;
    double pX = point.longitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;

    if ((pY > aY && pY > bY) || (pY < aY && pY < bY) || (pX > aX && pX > bX)) {
      return false;
    }

    if (pX < aX && pX < bX) {
      return true;
    }

    double m = (aY - bY) / (aX - bX);

    double x = (pY - bY + m * bX + m * m * pX) / (m * m + 1);

    return x > pX;
  }

  void addPolygon() {
    List<LatLng> polygonCoordinates = [
      LatLng(-8.160196, 113.720363),
      LatLng(-8.159211356625963, 113.72074965270397),
      LatLng(-8.158427, 113.721077),
      LatLng(-8.15816791731383, 113.72121032209817),
      LatLng(-8.155363353768134, 113.72276208474295),
      LatLng(-8.155346495030903, 113.7233347509108),
      LatLng(-8.155487, 113.723629),
      LatLng(-8.15538037443089, 113.7237392656189),
      LatLng(-8.155291758556917, 113.72457443735635),
      LatLng(-8.155322915349174, 113.7247593045013),
      LatLng(-8.155214056883109, 113.72478545603816),
      LatLng(-8.15534481979311, 113.72562699911745),
      LatLng(-8.155099888211316, 113.72570210097138),
      LatLng(-8.155341500937823, 113.72654297349261),
      LatLng(-8.155083957696679, 113.72670859990627),
      LatLng(-8.155221108341713, 113.72716676381422),
      LatLng(-8.154990150457476, 113.72721755397869),
      LatLng(-8.155045140441796, 113.72743023773916),
      LatLng(-8.15611605559663, 113.72717058078224),
      LatLng(-8.16046268775949, 113.72547806238292),
      LatLng(-8.160842629741886, 113.72507175302918),
      LatLng(-8.160449405693358, 113.72421176932542),
      LatLng(-8.160700593250922, 113.72409844837689),
      LatLng(-8.160793321613193, 113.72360964572987),
      LatLng(-8.161291333350428, 113.72322506548953),
      LatLng(-8.160996623292966, 113.72260346355264),
      LatLng(-8.160196964920255, 113.72035606335321),
    ];

    polygons.add(
      Polygon(
        polygonId: PolygonId('kampus_boundary'),
        points: polygonCoordinates,
        fillColor: Colors.blue.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: Colors.blue,
      ),
    );
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: polygonCoordinates.reduce(
            (value, element) => LatLng(
              value.latitude < element.latitude
                  ? value.latitude
                  : element.latitude,
              value.longitude < element.longitude
                  ? value.longitude
                  : element.longitude,
            ),
          ),
          northeast: polygonCoordinates.reduce(
            (value, element) => LatLng(
              value.latitude > element.latitude
                  ? value.latitude
                  : element.latitude,
              value.longitude > element.longitude
                  ? value.longitude
                  : element.longitude,
            ),
          ),
        ),
        50.0,
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
              forceAndroidLocationManager: true,
              desiredAccuracy: LocationAccuracy.best)
          .timeout(Duration(seconds: 15));
      updateLocation(position);

      // Mengecek apakah lokasi yang didapatkan valid (latitude dan longitude bukan 0.0)
      if (position.latitude != 0.0 && position.longitude != 0.0) {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17.0,
            ),
          ),
        );

        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId(position.toString()),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Lokasi Saat Ini'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );

        latitudeController.text = position.latitude.toString();
        longitudeController.text = position.longitude.toString();
        getAddressFromLatLng(position.latitude, position.longitude);
      } else {
        // Handle jika lokasi tidak valid
        Get.snackbar(
          'Error',
          'Gagal mendapatkan lokasi yang valid',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle kesalahan saat mendapatkan lokasi
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi saat ini: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goToKampus() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-8.15794, 113.72380),
          zoom: 17.0,
        ),
      ),
    );
  }
}
