import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lazaro_app/shared_preferences/preferences.dart';
import 'package:image/image.dart' as img;

import 'package:lazaro_app/widgets/widgets.dart';

class FaceIdentifyScreen extends StatefulWidget {
  const FaceIdentifyScreen({Key? key}) : super(key: key);

  @override
  State<FaceIdentifyScreen> createState() => _FaceIdentifyScreenState();
}

class _FaceIdentifyScreenState extends State<FaceIdentifyScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  List? predictions = [];
  List<String>? facesNames = [];
  bool loading = false;
  final ScrollController _scrollController = ScrollController();

  String getName(Map map) {
    return map['name'];
  }

  // Funcion para identificar rostros
  Future<List?> identifyFaces(XFile image, String localId) async {
    // url backend
    final url = Uri.parse(
        'https://des.digitalonboarding.es/lazaro/face/identify/$localId');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', image.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200) {
      return null;
    }
    final decodedData = json.decode(response.body);
    return decodedData['faces'];
  }

  // Get image from Camera
  void getImageCamera() async {
    facesNames = [];
    predictions = [];
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      imageFile = pickedImage;
      loading = true;
      await Future.delayed(const Duration(milliseconds: 300), () {
        scrollDown();
        setState(() {});
      });
      setState(() {});
      if (imageFile != null) {
        await identifyFaces(imageFile!, Preferences.localId)
            .then((value) async {
          predictions = value;
          setState(() {});
          if (predictions!.isNotEmpty) {
            for (var i in predictions!) {
              facesNames!.add(getName(i));
            }
            loading = false;
            setState(() {});
          } else {
            print('predictions esta vacio');
            loading = false;
            setState(() {});
          }
        });
      } else {
        print('imageFile es null');
        loading = false;
        setState(() {});
      }
    }
  }

  // Get image from gallery
  void getImageGallery() async {
    facesNames = [];
    predictions = [];
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile = pickedImage;
      loading = true;
      setState(() {});
      if (imageFile != null) {
        await identifyFaces(imageFile!, Preferences.localId)
            .then((value) async {
          predictions = value;
          // print(predictions![0]['name']);
          setState(() {});
          if (predictions!.isNotEmpty) {
            for (var i in predictions!) {
              facesNames!.add(getName(i));
            }
            loading = false;
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 300), () {
              scrollDown();
              setState(() {});
            });
          } else {
            print('predictions esta vacio');
            loading = false;
            setState(() {});
          }
        });
      } else {
        print('imageFile es null');
        loading = false;
        setState(() {});
      }
    }
  }

  // Scroll down function
  void scrollDown() async {
    final double end = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(end,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  void displayHelp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 5,
          title: const Text(
            'Ayuda',
            style: TextStyle(fontSize: 36),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Haz una foto, o selecciona una imagen de la galería.\n\nAutomaticamente detecta que rostros hay en la foto.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              SizedBox(
                width: 70,
                child: Image(
                  image: AssetImage('assets/face_id.png'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Aceptar',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Add listener to scrollcontroller
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Identificar rostros',
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              displayHelp();
            },
            child: Container(
              color: Colors.black.withAlpha(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  color: Colors.black.withAlpha(0),
                  child: GestureDetector(
                    child: const Icon(Icons.question_mark),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // drawer: const SideMenu(),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // const SizedBox(height: 40),
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(image: AssetImage('assets/face_id.png')),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.camera_alt_outlined, size: 32),
              onPressed: () {
                getImageCamera();
              },
              label: const Text(
                'Cámara',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.photo_outlined, size: 32),
              onPressed: () {
                getImageGallery();
              },
              label: const Text(
                'Galería',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 32),

            loading ? const CircularProgressIndicator() : const SizedBox(),

            if (predictions != null)
              predictions!.isNotEmpty
                  ? getTextWidgets(facesNames!)
                  : Container(),
            const SizedBox(height: 32),
            imageFile != null && !loading
                ? Image.file(File(imageFile!.path))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget getTextWidgets(List<String> strings) {
    return Column(
        children: strings
            .map((item) => Text(
                  item,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ))
            .toList());
  }
}
