import 'dart:async';
import 'dart:io';
import "dart:core";
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

List<CameraDescription> cameras;

class CameraWidget extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady = false;
  bool showCamera = true;
  String imagePath;

  /// Inputs
  TextEditingController itemController = TextEditingController();
  TextEditingController manufactureController = TextEditingController();
  TextEditingController expirationController = TextEditingController();

  ///initialise the view’s state
  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  ///
  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }

  ///scrollable layout
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: showCamera
                    ? Container(
                        height: 290,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Center(child: cameraPreviewWidget()),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            imagePreviewWidget(),
                            editCaptureControlRowWidget(),
                          ]),
              ),
              showCamera ? captureControlRowWidget() : Container(),
              cameraOptionsWidget(),
              pantryInfoInputsWidget()
            ],
          ),
        )));
  }

  ///This method returns an AspectRatio widget, which is responsible for
  ///returning the child with a specific aspect ratio.

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }

  ///container with SizedBox for displaying an Image from the imagePath
  Widget imagePreviewWidget() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: imagePath == null
            ? null
            : SizedBox(
                child: Image.file(File(imagePath)),
                height: 290.0,
              ),
      ),
    ));
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.teal,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  ///row for icons with onPressed
  Widget editCaptureControlRowWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.teal,
          onPressed: () => setState(() {
            showCamera = true;
          }),
        ),
      ),
    );
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          showCamera = false;
          imagePath = filePath;
        });
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  /// A user can choose between the front or back camera
  Widget cameraOptionsWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? cameraTogglesRowWidget() : Container(),
        ],
      ),
    );
  }

  Widget cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras != null) {
      if (cameras.isEmpty) {
        return const Text('No camera found');
      } else {
        for (CameraDescription cameraDescription in cameras) {
          toggles.add(
            SizedBox(
              width: 90.0,
              child: RadioListTile<CameraDescription>(
                title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
                groupValue: controller?.description,
                value: cameraDescription,
                onChanged: controller != null ? onNewCameraSelected : null,
              ),
            ),
          );
        }
      }
    }

    return Row(children: toggles);
  }

  ///reinitialise the controller with the current cameraDescription
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "ERROR",
          desc: "Camera not found.",
          buttons: [
            DialogButton(
              child: Text(
                "Please Retry",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.teal,
            ),
          ],
        ).show();
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "ERROR",
        desc: "Camera error.",
        buttons: [
          DialogButton(
            child: Text(
              "Please Retry",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.teal,
          ),
        ],
      ).show();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget pantryInfoInputsWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: itemController,
              onChanged: (v) => itemController.text = v,
              decoration: InputDecoration(
                labelText: 'Item',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: manufactureController,
              onChanged: (v) => manufactureController.text = v,
              decoration: InputDecoration(
                labelText: "Manufacture",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              controller: expirationController,
              onChanged: (v) => expirationController.text = v,
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return RaisedButton(
                onPressed: () => {},
                color: Colors.teal,
                child: Text('Add Item'),
              );
            },
          ),
        ),
      ],
    );
  }
}
/**
 * in android/app/build.gradle set minSdkVersion to 21
 *
 * in ios/Runner/Info.plist add the following:
 *   <key>NSCameraUsageDescription</key>
 *   <string>Can I use the camera please?</string>
 *   <key>NSMicrophoneUsageDescription</key>
 *   <string>Can I use the mic please?</string>
 *
 * in pubspec.yaml add the following:
 *    dependencies:
 *   flutter:
 *    sdk: flutter
 *   http: 0.12.0+1
 *   camera: ^0.4.2
 *   path_provider: ^1.5.1
 *   rflutter_alert: ^1.0.3
 *
 */
