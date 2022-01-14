import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'ScannerUtils.dart';
import 'detector_painters.dart';

class CameraPreviewScanner extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState ();

}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController _camera;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;
  final FaceDetector faceDetector = GoogleVision.instance.faceDetector(
    FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true,
        enableContours: true
    )
  );
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Drowsiness Monitoring',
        style: TextStyle(color: Colors.white),),
        //?centerTitle: true,
      ),
      body: _buildImage(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30,
          ),
          FloatingActionButton(
            onPressed: _toggleCameraDirection,
            child: _direction == CameraLensDirection.front
                ? Icon(Icons.camera_rear)
                : Icon(Icons.camera_front),
          ),
        ],
      ),
    );

  }
  _initializeCamera() async{
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);
    setState(() {});
    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.medium
          : ResolutionPreset.high,
    );
    await _camera.initialize().catchError((onError) => print(onError));
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      ScannerUtils.detect(
        image: image,
        detectInImage: faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }
  Widget _buildImage()
  {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.white,
      child: _camera == null
          ? Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_camera),
            _buildResults(),
            // Text(face)
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _camera.dispose().then((_) {
      faceDetector.close();
    });

    super.dispose();
  }
  Widget _buildResults() {
    Text noResultsText = Text('No Face detected yet!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }
    CustomPainter painter;
    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );
    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }
  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }
    await _camera.stopImageStream();
    await _camera.dispose();
    setState(() {
      _camera = null;
    });
    _initializeCamera();
  }
}

