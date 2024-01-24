// To parse this JSON data, do
//
//     final appUser = appUserFromJson(jsonString);

import 'dart:convert';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

class AppUser {
    String ad;
    String email;
    String foto;
    String id;
    String sifre;
    String soyad;
    String tc;

    AppUser({
        required this.ad,
        required this.email,
        required this.foto,
        required this.id,
        required this.sifre,
        required this.soyad,
        required this.tc,
    });

    factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        ad: json["ad"],
        email: json["email"],
        foto: json["foto"],
        id: json["id"],
        sifre: json["sifre"],
        soyad: json["soyad"],
        tc: json["tc"],
    );

    Map<String, dynamic> toJson() => {
        "ad": ad,
        "email": email,
        "foto": foto,
        "id": id,
        "sifre": sifre,
        "soyad": soyad,
        "tc": tc,
    };
}
