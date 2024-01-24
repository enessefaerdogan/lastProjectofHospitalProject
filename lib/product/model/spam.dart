// To parse this JSON data, do
//
//     final spam = spamFromJson(jsonString);

import 'dart:convert';

Spam spamFromJson(String str) => Spam.fromJson(json.decode(str));

String spamToJson(Spam data) => json.encode(data.toJson());

class Spam {
    String degerlendirmeId;
    String id;
    String kullanici;
    String sebep;

    Spam({
        required this.degerlendirmeId,
        required this.id,
        required this.kullanici,
        required this.sebep,
    });

    factory Spam.fromJson(Map<String, dynamic> json) => Spam(
        degerlendirmeId: json["degerlendirme_id"],
        id: json["id"],
        kullanici: json["kullanici"],
        sebep: json["sebep"],
    );

    Map<String, dynamic> toJson() => {
        "degerlendirme_id": degerlendirmeId,
        "id": id,
        "kullanici": kullanici,
        "sebep": sebep,
    };
}
