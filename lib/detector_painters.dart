import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class FaceDetectorPainter extends CustomPainter {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Contact");
  TwilioFlutter twilioFlutter;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  FaceDetectorPainter(this.absoluteImageSize, this.faces);
  int colorInt = 1;
  final Size absoluteImageSize;
  final List<Face> faces;
  // final List<Pose> poses;
  var data = [];
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.limeAccent,
    Colors.orange
  ];
  @override
  void initState() {}
  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;
    //for (Face face in faces) {
    try {
      // faces.sort()=>a.;
      Face face = faces[0];
      double averageEyeOpenProb =
          (face.leftEyeOpenProbability + face.rightEyeOpenProbability) / 2.0;
      double l = face.leftEyeOpenProbability;
      double r = face.rightEyeOpenProbability;
      // print("hello");
      //print("lefteyeprob${face.leftEyeOpenProbability}");
      //print("righteyeprob${face.rightEyeOpenProbability}");
      //  print(averageEyeOpenProb);
      if (l < 0.4 && r < 0.4) {
        print("lefteyeprob" + l.toString());
        print("righteyeprob" + r.toString());
        //print("Alert");
        assetsAudioPlayer.open(Audio('assets/alarm.wav'));
        getData();
        colorInt = 0;
      } else {
        assetsAudioPlayer.stop();
        colorInt = 1;
      }
      canvas.drawRect(
          // face.boundingBox,
          Rect.fromLTRB(
            face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..color = colors[colorInt]);
    } catch (e) {
      print("noFaceDetected");
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }

  Future getData() async {
    await dbRef.orderByKey().once().then((DataSnapshot dataSnapshot) => {
          dataSnapshot.value.forEach((key, values) {
            data.add(values);
          }),
        });
    var re = RegExp(r'\d{1}');
    final List<String> phone =
        data.map((e) => e["Phone"].toString().replaceFirst(re, '+92')).toList();
    twilioFlutter = new TwilioFlutter(
        accountSid: 'AC75e54751e1a8d2ddce84f3b12103c8a0',
        authToken: '1501fd9c1a28ce0ec4cb2b9b9c14a5ab',
        twilioNumber: '+15614755686');
    for (String s in phone) {
      try {
        await twilioFlutter.sendSMS(
            toNumber: s.toString(),
            messageBody:
                "Your Driver is feeling Drowsy. Please contact him/her to avoid any mishap");
        print("Sms Sent to number");
      } catch (e) {
        print(e.toString());
      }

    }
  }
}
