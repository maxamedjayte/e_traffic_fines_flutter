import 'package:camera/camera.dart';
import 'package:e_traffic_fines/screens/register_car_fine.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../common/api.dart';

class CameraScan extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScan({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScan> createState() => _CameraScanState();
}

class _CameraScanState extends State<CameraScan> {
  late CameraController _controller;
  bool isLoading = false;
  String scannedText = '';
  String statusText = '';
  XFile? scannedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) => {
          setState(
            () {},
          )
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 100),
      width: double.infinity,
      height: double.infinity,
      child: isLoading
          ? Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black)),
                  width: 280,
                  height: 400,
                  child: Container(
                      child: Center(child: CircularProgressIndicator())),
                ),
              ],
            )
          : Column(
              children: [
                Text(
                  scannedText,
                  style: TextStyle(color: Colors.red),
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey, width: 2)),
                  child: CameraPreview(_controller),
                ),
                Container(
                    width: 300,
                    child: TextButton(
                      onPressed: () async {
                        var thePlate = '';
                        scannedImage = await _controller.takePicture();

                        isLoading = true;
                        setState(() {});
                        thePlate = await getRecognisedText(scannedImage!);
                        bool plateExist = false;
                        plateExist = await TrafficDataService()
                            .getThisPlateExist(thePlate);
                        if (plateExist) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateCarFine(
                                      scannedCarPlate: thePlate)));
                        } else {
                          isLoading = false;
                          scannedText = 'Not Founded The Plate Plase Try Again';
                          setState(() {});
                        }
                      },
                      child: Text(
                        'scan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).focusColor)),
                    ))
              ],
            ),
    ));
  }

  Future<String> getRecognisedText(XFile image) async {
    var plate = '';
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    var recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    // scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        plate = line.text;
        // scannedText = scannedText + line.text + "\n";
        print(line.text);
      }
    }
    setState(() {});
    return plate;
  }
}
