


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Silinecek extends StatefulWidget {
  const Silinecek({super.key});

  @override
  State<Silinecek> createState() => _SilinecekState();
}

class _SilinecekState extends State<Silinecek> {
  double userLatitude = 0;
  double userLongitude = 0;

  _getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print("Konum izni reddedildi");
    } else if (permission == LocationPermission.deniedForever) {
      print("Konum izni kalıcı olarak reddedildi");
    } else {
      print("Konum izni sağlandı");
      _getLocation();
    }
  }
  _getLocation() async {
    try {
      // Geolocator paketini kullanarak konumu al
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Konumu ekrana yazdır
      setState(() {
        userLatitude  = position.latitude;
        userLongitude = position.longitude;
      print(userLatitude.toString());
      
      });

    } catch (e) {
      print("Hata: $e");
    }
  }

  String realDistance = "";
  double haversine(double lat1, double lon1, double lat2, double lon2) {
  // Dünya yarıçapı (km)
  const double R = 6371.0;

  // Latitude ve longitude değerlerini radian cinsine dönüştür
  lat1 = _toRadians(lat1);
  lon1 = _toRadians(lon1);
  lat2 = _toRadians(lat2);
  lon2 = _toRadians(lon2);

  // Haversine formülü
  double dlat = lat2 - lat1;
  double dlon = lon2 - lon1;
  double a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Mesafeyi hesapla
  double distance = R * c;

  setState(() {
    realDistance = distance.toString();
  });

  return distance;
}

double _toRadians(double degree) {
  return degree * (pi / 180.0);
}

bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          SafeArea(child: ElevatedButton(onPressed: ()async{
              await _getLocationPermission();
              await haversine(userLatitude,userLongitude,37.47207129652793, 30.567647497590333);
              print(realDistance);
          }, child: Text("Anlık Konum"))),

          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("En yakın hastaneler"),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
        ],
      ),

    );
  }
}