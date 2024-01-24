// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    String alankullanici;
    String atankullanici;
    String id;
    String mesaj;
    String saat;
    int sira;
    String tarih;

    Message({
        required this.alankullanici,
        required this.atankullanici,
        required this.id,
        required this.mesaj,
        required this.saat,
        required this.sira,
        required this.tarih,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        alankullanici: json["alankullanici"],
        atankullanici: json["atankullanici"],
        id: json["id"],
        mesaj: json["mesaj"],
        saat: json["saat"],
        sira: json["sira"],
        tarih: json["tarih"],
    );

    Map<String, dynamic> toJson() => {
        "alankullanici": alankullanici,
        "atankullanici": atankullanici,
        "id": id,
        "mesaj": mesaj,
        "saat": saat,
        "sira": sira,
        "tarih": tarih,
    };
}
