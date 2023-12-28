import 'dart:convert';
import 'package:e_traffic_fines/data/json.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/modals.dart';

class TrafficDataService {
  static const String baseUlrOrg = 'https://e-traffic-fines.herokuapp.com';
  static const String baseUrl = 'e-traffic-fines.herokuapp.com';
  Future<List<CarFines>> getCarFines() async {
    List<CarFines> carFinesList = [];
    var response = await http
        .get(Uri.https(TrafficDataService.baseUrl, '/api/carFines-list/'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var crFines in data) {
        carFinesList.add(CarFines.fromJson(crFines));
      }
      return carFinesList;
    } else {
      throw Exception('Failed To load car fines');
    }
  }

  Future<List<UserProfile>> getUserProfile() async {
    List<UserProfile> userProfileList = [];
    var response = await http
        .get(Uri.https(TrafficDataService.baseUrl, '/api/userProfile-list/'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var crFines in data) {
        userProfileList.add(UserProfile.fromJson(crFines));
      }
      return userProfileList;
    } else {
      throw Exception('Failed To load car fines');
    }
  }

  Future<Cars> getCarInfo(carId) async {
    var response = await http
        .get(Uri.https(TrafficDataService.baseUrl, '/api/car-detail/$carId/'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Cars.fromJson(data);
    } else {
      throw Exception('Failed To load car fines');
    }
  }

  Future<bool> getThisPlateExist(thePlate) async {
    var data;
    bool itExist = false;
    try {
      var response = await http.get(Uri.https(baseUrl, '/api/car-list/'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        for (var cr in data) {
          if (cr['plateNo'] == thePlate) {
            itExist = true;
            break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return itExist;
  }

  Future<int> getThisPlateCarId(thePlate) async {
    var data;
    int carId = 1;
    try {
      var response = await http.get(Uri.https(baseUrl, '/api/car-list/'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        for (var cr in data) {
          if (cr['plateNo'] == thePlate) {
            carId = cr['id'];
            break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return carId;
  }

  Future<bool> paidTheMoney(theCarFine) async {
    bool isFixed = false;
    var response =
        await http.post(Uri.https(baseUrl, '/api/carFines-update/$theCarFine/'),
            headers: {
              'Content-Type': 'application/json',
              'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
            },
            body: jsonEncode({
              'fixed': true,
              'paided': true,
              'balance': 0,
            }),
            encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      isFixed = true;
    }
    return isFixed;
  }

  Future<bool> fixTheFine(theCarFine) async {
    bool isFixed = false;
    var response =
        await http.post(Uri.https(baseUrl, '/api/carFines-update/$theCarFine/'),
            headers: {
              'Content-Type': 'application/json',
              'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
            },
            body: jsonEncode({
              'fixed': true,
            }),
            encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      isFixed = true;
    }
    return isFixed;
  }

  Future<List> getRegistredCar() async {
    var data;
    try {
      var response = await http.get(Uri.https(baseUrl, '/api/car-list/'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);

        // print(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<List> getRegistredFine() async {
    var data;
    try {
      var response = await http.get(Uri.https(baseUrl, '/api/fine-list/'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);

        // print(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  getDashboardCounts() async {
    var unfixedCarfines = 0;
    var userCarCount = 0;
    var allCarsCout = 0;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var data;

    try {
      var response = await http.get(Uri.https(baseUrl, '/api/carFines-list/'));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        for (var crFines in data) {
          if (crFines['fixed'] == false) {
            unfixedCarfines++;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    try {
      var response = await http.get(Uri.https(baseUrl, '/api/car-list/'));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        for (var cr in data) {
          allCarsCout++;
          if (cr['theOwner'].toString() == _prefs.getString('userId')) {
            if (currentUser['is_staff'] == false) {
              userCarCount++;
            }
          } else {}
        }
      }
    } catch (e) {
      print(e);
    }
    print('unfixed ${unfixedCarfines}');
    currentUser['unfixedFines'] = unfixedCarfines;
    currentUser['userCarCount'] = userCarCount;
    currentUser['allCarsCount'] = allCarsCout;
  }

  Future<bool> singInTheUser(
      {required String username, required String password}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool loggedIn = false;
    var data;
    try {
      var response =
          await http.get(Uri.https(baseUrl, '/api/userProfile-list/'));

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        for (var usr in data) {
          var isStaff = false;
          if (usr['username'] == username && usr['password'] == password) {
            _prefs.setString('userId', usr['id'].toString());
            if (usr['userType'] == 'Normal Owner') {
              isStaff = false;
              loggedIn = true;
            } else if (usr['userType'] == 'Staff') {
              isStaff = true;
              loggedIn = true;
            } else {
              loggedIn = false;
              _prefs.remove('userId');
              break;
            }
            currentUser = {
              'id': usr['id'],
              'is_staff': isStaff,
              'name': usr['fullName'],
              'profileImage': '$baseUlrOrg${usr['prfileImage']}',
              "username": usr['username'],
              'number': usr['number'],
              'userType': usr['userType'],
              'address': usr['address'],
              'job': usr['job'],
              'info': usr['info'],
              'userCarCount': 0,
              'allCarsCount': 0,
              'unfixedFines': 0
            };
            break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return loggedIn;
  }

  getTheUserInfo({required String userId}) async {
    var data;
    try {
      var response = await http
          .get(Uri.https(baseUrl, '/api/userProfile-detail/' + userId + '/'));

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        var isStaff = false;
        if (data['userType'] == 'Normal Owner') {
          isStaff = false;
        } else {
          isStaff = true;
        }
        currentUser = {
          'id': data['id'],
          'is_staff': isStaff,
          'name': data['fullName'],
          'profileImage': '$baseUlrOrg${data['prfileImage']}',
          "username": data['username'],
          'number': data['number'],
          'userType': data['userType'],
          'address': data['address'],
          'job': data['job'],
          'info': data['info'],
          'userCarCount': 0,
          'allCarsCount': 0,
          'unfixedFines': 0
        };
      }
    } catch (e) {
      print(e);
    }
  }
}
