import 'package:e_traffic_fines/common/api.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'dart:convert';

List<UserProfile> userProfileFromJson(String str) => List<UserProfile>.from(
    json.decode(str).map((x) => UserProfile.fromJson(x)));

String userProfileToJson(List<UserProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfile {
  UserProfile({
    required this.id,
    required this.username,
    required this.prfileImage,
    required this.fullName,
    required this.password,
    required this.number,
    this.address,
    this.job,
    required this.userType,
    required this.dateReg,
    required this.info,
    required this.user,
  });

  final int id;
  final String username;
  final String prfileImage;
  final String fullName;
  final String password;
  final String number;
  final String? address;
  final String? job;
  final String userType;
  final DateTime dateReg;
  final String info;
  final int user;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        username: json["username"],
        prfileImage: TrafficDataService.baseUlrOrg + json["prfileImage"],
        fullName: json["fullName"],
        password: json["password"],
        number: json["number"],
        address: json["address"],
        job: json["job"],
        userType: json["userType"],
        dateReg: DateTime.parse(json["dateReg"]),
        info: json["info"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "prfileImage": TrafficDataService.baseUlrOrg + prfileImage,
        "fullName": fullName,
        "password": password,
        "number": number,
        "address": address,
        "job": job,
        "userType": userType,
        "dateReg": dateReg.toIso8601String(),
        "info": info,
        "user": user,
      };
}

List<Cars> carsFromJson(String str) =>
    List<Cars>.from(json.decode(str).map((x) => Cars.fromJson(x)));

String carsToJson(List<Cars> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cars {
  Cars({
    required this.id,
    required this.ownerName,
    required this.ownerNumber,
    required this.name,
    required this.plateNo,
    required this.image,
    required this.dateTimeReg,
    required this.desc,
    required this.theOwner,
  });

  final int id;
  final String ownerName;
  final String ownerNumber;
  final String name;
  final String plateNo;
  final String image;
  final DateTime dateTimeReg;
  final String desc;
  final int theOwner;

  factory Cars.fromJson(Map<String, dynamic> json) {
    return Cars(
      id: json["id"],
      ownerName: json["ownerName"],
      ownerNumber: json["ownerNumber"],
      name: json["name"],
      plateNo: json["plateNo"],
      image: TrafficDataService.baseUlrOrg + json["image"],
      dateTimeReg: DateTime.parse(json["dateTimeReg"]),
      desc: json["desc"],
      theOwner: json["theOwner"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerName": ownerName,
        "ownerNumber": ownerNumber,
        "name": name,
        "plateNo": plateNo,
        "image": TrafficDataService.baseUlrOrg + image,
        "dateTimeReg": dateTimeReg.toIso8601String(),
        "desc": desc,
        "theOwner": theOwner,
      };
}

List<CarFines> carFinesFromJson(String str) =>
    List<CarFines>.from(json.decode(str).map((x) => CarFines.fromJson(x)));

String carFinesToJson(List<CarFines> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarFines {
  CarFines({
    required this.id,
    required this.fineTitle,
    required this.penallyMoney,
    required this.carName,
    required this.carTargo,
    required this.carImage,
    required this.ownerName,
    required this.ownerImage,
    this.imageArea,
    required this.ownerType,
    required this.ownerNumber,
    required this.dateTimeReg,
    required this.desc,
    required this.fixed,
    required this.balance,
    required this.paided,
    required this.theCar,
    required this.theOwner,
    required this.theFine,
  });

  final int id;
  final String fineTitle;
  final double penallyMoney;
  final String carName;
  final String carTargo;
  final String carImage;
  final String ownerName;
  final String ownerImage;
  final String? imageArea;
  final String ownerType;
  final String ownerNumber;
  final DateTime dateTimeReg;
  final String desc;
  late final bool fixed;
  final double balance;
  final bool paided;
  final int theCar;
  final int theOwner;
  final int theFine;

  factory CarFines.fromJson(Map<String, dynamic> json) => CarFines(
        id: json["id"],
        fineTitle: json["fineTitle"],
        penallyMoney: json["penallyMoney"],
        carName: json["carName"],
        carTargo: json["carTargo"],
        carImage: TrafficDataService.baseUlrOrg + json["carImage"],
        ownerName: json["ownerName"],
        ownerImage: TrafficDataService.baseUlrOrg + json["ownerImage"],
        imageArea: json["imageArea"] == null
            ? json["imageArea"]
            : TrafficDataService.baseUlrOrg + json["imageArea"],
        ownerType: json["ownerType"],
        ownerNumber: json["ownerNumber"],
        dateTimeReg: DateTime.parse(json["dateTimeReg"]),
        desc: json["desc"],
        fixed: json["fixed"],
        balance: json["balance"],
        paided: json["paided"],
        theCar: json["theCar"],
        theOwner: json["theOwner"],
        theFine: json["theFine"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fineTitle": fineTitle,
        "penallyMoney": penallyMoney,
        "carName": carName,
        "carTargo": carTargo,
        "carImage": TrafficDataService.baseUlrOrg + carImage,
        "ownerName": ownerName,
        "ownerImage": TrafficDataService.baseUlrOrg + ownerImage,
        "imageArea":
            imageArea == null ? '' : TrafficDataService.baseUlrOrg + imageArea!,
        "ownerType": ownerType,
        "ownerNumber": ownerNumber,
        "dateTimeReg": dateTimeReg.toIso8601String(),
        "desc": desc,
        "fixed": fixed,
        "balance": balance,
        "paided": paided,
        "theCar": theCar,
        "theOwner": theOwner,
        "theFine": theFine,
      };
}

class Fines {
  Fines({
    required this.id,
    required this.fineTitle,
    required this.price,
    this.info,
  });

  final int id;
  final String fineTitle;
  final double price;
  final String? info;

  factory Fines.fromJson(Map<String, dynamic> json) => Fines(
        id: json["id"],
        fineTitle: json["fineTitle"],
        price: json["price"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fineTitle": fineTitle,
        "price": price,
        "info": info,
      };
}
