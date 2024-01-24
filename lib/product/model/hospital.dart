// To parse this JSON data, do
//
//     final hospital = hospitalFromJson(jsonString);

import 'dart:convert';

Hospital hospitalFromJson(String str) => Hospital.fromJson(json.decode(str));

String hospitalToJson(Hospital data) => json.encode(data.toJson());

class Hospital {
    String ad;
    String adres;
    String foto;
    String id;
    String il;
    String ilce;
    String latitude;
    String longitude;
    String tel;
    String website;

    Hospital({
        required this.ad,
        required this.adres,
        required this.foto,
        required this.id,
        required this.il,
        required this.ilce,
        required this.latitude,
        required this.longitude,
        required this.tel,
        required this.website,
    });

    factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        ad: json["ad"],
        adres: json["adres"],
        foto: json["foto"],
        id: json["id"],
        il: json["il"],
        ilce: json["ilce"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tel: json["tel"],
        website: json["website"],
    );

    Map<String, dynamic> toJson() => {
        "ad": ad,
        "adres": adres,
        "foto": foto,
        "id": id,
        "il": il,
        "ilce": ilce,
        "latitude": latitude,
        "longitude": longitude,
        "tel": tel,
        "website": website,
    };
}
