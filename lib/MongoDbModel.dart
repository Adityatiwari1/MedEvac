// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
    ObjectId id;
    String firstName;
    String lastName;
    int age;
    String rank;
    String bloodGroup;
    List<String> medicalHistory;
    String img;

    MongoDbModel({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.age,
        required this.rank,
        required this.bloodGroup,
        required this.medicalHistory,
        required this.img,
    });

    factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        age: json["Age"],
        rank: json["rank"],
        bloodGroup: json["bloodGroup"],
        medicalHistory: List<String>.from(json["medicalHistory"].map((x) => x)),
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "Age": age,
        "rank": rank,
        "bloodGroup": bloodGroup,
        "medicalHistory": List<dynamic>.from(medicalHistory.map((x) => x)),
        "img": img,
    };
}
