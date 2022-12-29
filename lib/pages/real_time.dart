import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'dart:ui' as ui;
import 'package:finger_painter/finger_painter.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RealTimePage extends StatefulWidget {
  const RealTimePage({super.key});

  @override
  State<RealTimePage> createState() => _RealTimePageState();
}

class _RealTimePageState extends State<RealTimePage> {
  Model? mnistModel;
  String? prediction;
  late PainterController painterController;

  @override
  void initState() {
    super.initState();
    loadModel();
    painterController = PainterController()
      ..setStrokeColor(Colors.white)
      ..setMinStrokeWidth(20)
      ..setMaxStrokeWidth(20)
      ..setBlurSigma(0.0)
      ..setPenType(PenType.pencil)
      ..setBlendMode(ui.BlendMode.srcOver);
  }

  Future loadModel() async {
    String pathModel = "assets/model/student_model_mobile.pt";
    try {
      mnistModel = await PyTorchMobile.loadModel(pathModel);
    } on PlatformException {
      print("only supported for android and ios so far");
    }
  }

  Future predictPainting() async {
    IMG.Image? img = IMG.decodeImage(painterController.getImageBytes()!);
    IMG.Image resized = IMG.copyResize(img!, width: 28, height: 28);
    Uint8List resizedImg = Uint8List.fromList(IMG.encodePng(resized));

    Directory documentDir = await getApplicationDocumentsDirectory();
    File file = File(path.join(documentDir.path, "temp"));
    file.writeAsBytesSync(resizedImg);

    String? number = await mnistModel!
        .getImagePrediction(File(file.path), 28, 28, "assets/label/label.csv");

    setState(() {
      prediction = number;
    });
  }

  void refresh() {
    painterController.clearContent(
        clearColor: const ui.Color.fromARGB(255, 0, 0, 0));
    setState(() {
      prediction = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          Painter(
            controller: painterController,
            backgroundColor: const ui.Color.fromARGB(255, 0, 0, 0),
            size: const Size(330, 330),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: predictPainting, child: const Text("Confirm")),
              const SizedBox(
                width: 60,
              ),
              ElevatedButton(onPressed: refresh, child: const Text("Refresh")),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Recognition is :',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            '$prediction',
            style: Theme.of(context).textTheme.headline2,
          ),
          const Spacer(),
          Text(
            'Created by Mingwei He',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
