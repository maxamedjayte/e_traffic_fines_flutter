import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:camera/camera.dart';
import 'package:e_traffic_fines/common/api.dart';
import 'package:e_traffic_fines/screens/camera_scan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../common/theme_helper.dart';
import '../model/modals.dart';
import '../theme/colors.dart';
import '../widgets/appbar_box.dart';
import '../widgets/icon_box.dart';
import '../widgets/notification_box.dart';

class CreateCarFine extends StatefulWidget {
  final String? scannedCarPlate;
  // final int? carId;

  const CreateCarFine({Key? key, this.scannedCarPlate});

  @override
  State<CreateCarFine> createState() => _CreateCarFineState();
}

class _CreateCarFineState extends State<CreateCarFine> {
  bool fineRegistring = false;
  File? imageArea;
  int? carId = 1;
  getAreaImage() async {
    final ImagePicker _picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    imageArea = File(photo!.path);
    setState(() {});
  }

  File? image;
  late Cars carInfo;
  var desc;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  List<Cars> _cars = [];
  List<Fines> _fines = [];
  late List<Fines> _selectedCar;

  Future<List<Fines>> getFines() async {
    var response = await http
        .get(Uri.https(TrafficDataService.baseUrl, '/api/fine-list/'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var crFines in data) {
        _fines.add(Fines.fromJson(crFines));
      }

      return _fines;
    } else {
      throw Exception('Failed To load fines');
    }
  }

  runFuncions() async {
    await getFines();
    isLoading = false;
    if (widget.scannedCarPlate != null) {
      carId =
          await TrafficDataService().getThisPlateCarId(widget.scannedCarPlate);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    runFuncions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      floatingActionButton: fineRegistring
          ? Center(
              child: CircularProgressIndicator(),
            )
          : getButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: fineRegistring
          ? Center(
              child: CircularProgressIndicator(),
            )
          : getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(children: [
              getAppBar(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: widget.scannedCarPlate == null
                        ? Text(
                            'Scan Car Image',
                            style: Theme.of(context).textTheme.headline6,
                          )
                        : Text(
                            'Scanned ${widget.scannedCarPlate!}',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  InkWell(
                    onTap: () async {
                      await availableCameras().then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        CameraScan(cameras: value))))
                          });
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 150,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Colors.white),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: image == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 80,
                                color: Colors.grey.shade300,
                              )
                            : Image.file(
                                image!,
                                fit: BoxFit.fill,
                              )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  getAreaImage();
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: imageArea == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 80,
                            color: Colors.grey.shade300,
                          )
                        : Image.file(
                            imageArea!,
                            fit: BoxFit.fill,
                          )),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey)),
                      child: MultiSelectDialogField<Fines>(
                        backgroundColor: Colors.white,
                        searchable: true,
                        listType: MultiSelectListType.CHIP,
                        title: const Text('Choose The The Fine'),
                        buttonText: const Text("Choose The Fine"),
                        items: _fines
                            .map((e) => MultiSelectItem(
                                e, '${e.fineTitle} - ${e.price}'))
                            .toList(),
                        onConfirm: (values) {
                          _selectedCar = values;
                        },
                      ),
                    ),
              const SizedBox(height: 10),
              widget.scannedCarPlate != null
                  ? FutureBuilder<Cars>(
                      future: TrafficDataService().getCarInfo(carId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var carInf = snapshot.data!;
                          carInfo = snapshot.data!;
                          return Column(children: [
                            SizedBox(height: 15),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: carInf.name),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: ThemeHelper()
                                    .textInputDecoration('The Car', 'Car-Name'),
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: carInf.ownerName),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: ThemeHelper().textInputDecoration(
                                    'The Owner', 'Car-Owner'),
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: carInf.plateNo),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: ThemeHelper().textInputDecoration(
                                    'The Plate', 'Car-Plate'),
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                maxLines: 10,
                                onSaved: (theDesc) {
                                  desc = theDesc!;
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Enter The Desc', 'Desc'),
                              ),
                            ),
                          ]);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })
                  : Container(),
              SizedBox(height: 40)
            ])));
  }

  getAppBar() {
    return AppBarBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconBox(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "Register A New Fine",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          )),
          SizedBox(width: 15),
          InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => CreateCarFine())));
              },
              child: NotificationBox())
        ],
      ),
    );
  }

  getButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: 20, bottom: 10),
          child: ElevatedButton(
            style: ThemeHelper().buttonStyle(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
              child: Text(
                'Register'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            onPressed: () async {
              _formKey.currentState!.save();
              fineRegistring = true;
              setState(() {});
              var postUri = Uri.parse(
                  '${TrafficDataService.baseUlrOrg}/api/carFines-create/');

              http.MultipartRequest request =
                  http.MultipartRequest("POST", postUri);

              http.MultipartFile multipartFile =
                  await http.MultipartFile.fromPath(
                      'imageArea', imageArea!.path);

              request.fields['theCar'] = carId.toString();
              request.fields['theFine'] = _selectedCar[0].id.toString();
              request.fields['theOwner'] = carInfo.theOwner.toString();
              request.fields['desc'] = desc;
              request.fields['dateTimeReg'] = DateTime.now().toString();
              request.files.add(multipartFile);

              http.StreamedResponse response = await request.send();

              response.stream.transform(utf8.decoder).listen((value) {
                print(value);
              });

              fineRegistring = false;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  uploadCarFine() async {
    var dio = Dio();
    var fileName = imageArea!.path.split('/').last;

    // var postUri =
    //     Uri.parse('${TrafficDataService.baseUlrOrg}/api/carFines-create/');
    // var request = http.MultipartRequest("POST", postUri);
    // request.fields['theCar'] = widget.carId.toString();
    // request.fields['theFine'] = _selectedCar[0].id.toString();
    // request.fields['theOwner'] = carInfo.theOwner.toString();
    // // request.fields['desc'] = carInfo.theOwner.toString();
    // request.fields['dateTimeReg'] = '2022-06-27T17:24:00Z';
    // request.files.add(http.MultipartFile.fromBytes(
    //     'imageArea', await File.fromUri(imageArea!.uri).readAsBytes(),
    //     contentType: MediaType('image', 'jpg')));
    // var res = await request.send();

    //

    // FormData formData=FormData.fromMap('imageArea':await MultipartFile.fromFile(imageArea!.path,filename: fileName,contentType: MediaType('image','png')),'type');
    // FormData formData =FormData.fromMap('imageArea':await MultipartFile.fromFile(imageArea!.path,filename: fileName,contentType:  MediaType()),'type':'image/png');
//     http.MultipartRequest multipartRequest = new http.MultipartRequest('POST',url);
// http.MultipartFile file = new http.MultipartFile.fromBytes('file', await
// imageArea!.path.readAsBytes(),contentType: MediaType('image','jpg));  // MediaType class is not defined
// multipartRequest.files.add(file);
    // var response = await http.post(
    //     Uri.https(TrafficDataService.baseUrl, '/api/carFines-create/'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    //     },
    //     body: jsonEncode({
    //       'theCar': '_carSelectIdTofine',
    //       'theFine': 'carInfo.toString()',
    //       'dateTimeReg': 'dateTime.toString()',
    //       'theOwner': ''
    //     }),
    //     encoding: Encoding.getByName("utf-8"));
    // var request = http.MultipartRequest('POST',
    //     Uri.parse('${TrafficDataService.baseUlrOrg}/api/carFines-create/'));
    // request.fields['theCar'] = widget.carId.toString();
    // request.fields['theFine'] = _selectedCar[0].id.toString();
    // request.fields['theOwner'] = carInfo.theOwner.toString();
    // request.fields['desc'] = carInfo.theOwner.toString();
    // request.fields['dateTimeReg'] = '2022-06-27T17:24:00Z';
    // var stream = http.ByteStream(imageArea!.openRead());
    // stream.cast();
    // var lenght = await imageArea!.length();
    // request.files.add(http.MultipartFile('imageArea', stream, lenght));
    // request.files.add(http.MultipartFile.fromBytes(
    //     'imageArea', (File(imageArea!.path).readAsBytesSync()),
    //     filename: 'fineImg'));
    // var res = await request.send();
    // res.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    // print(res.request!.method);
    // if (response.statusCode == 200) {
    //   await http.post(
    //       Uri.https(TrafficDataService.baseUrl, '/api/report-create/'),
    //       headers: {
    //         'Content-Type': 'application/json',
    //         'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    //       },
    //       body: jsonEncode({
    //         'title': 'Assining car fines',
    //         'info': 'a car was assained a new fine titlefineTitle}',
    //       }),
    //       encoding: Encoding.getByName("utf-8"));
    // }
  }
}
