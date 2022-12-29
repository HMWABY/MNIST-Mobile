import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  Model? mnistModel;
  String? prediction;
  File? _image;
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    String pathModel = "assets/model/student_model_mobile.pt";
    try {
      mnistModel = await PyTorchMobile.loadModel(pathModel);
    } on PlatformException {
      print("only supported for android and ios so far");
    }
  }

  Future recognizeImage() async {
    final image = await _picker.pickImage(
      source: (Platform.isIOS ? ImageSource.gallery : ImageSource.camera),
      maxHeight: 28,
      maxWidth: 28,
    );
    String? number = await mnistModel!.getImagePrediction(
        File(image!.path), 28, 28, "assets/label/label.csv");

    setState(() {
      setState(() {
        _image = File(image.path);
      });
      prediction = number;
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
          _image == null
              ? const SizedBox(
                  width: 330,
                  height: 330,
                )
              : SizedBox(
                  width: 330,
                  height: 330,
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: recognizeImage,
            child: const Text("Select Image"),
          ),
          const SizedBox(
            width: 60,
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
