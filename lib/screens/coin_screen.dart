import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({Key? key}) : super(key: key);

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Image? _imageResult;
  int? _totalAmount;
  Map? _coins;
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  String processText(Map coins) {
    String outText = '';
    for (var entry in coins['coins'].entries) {
      if ((entry.value['count']) > 0) {
        if ((entry.value['count']) > 1) {
          outText = '$outText${entry.value['count']} monedas de ${entry.key}\n';
        } else {
          outText = '$outText${entry.value['count']} moneda de ${entry.key}\n';
        }
      }
    }
    return outText;
  }

  void scrollUp() async {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  void scrollDown() async {
    _scrollController.animateTo(380,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  // decode b64 to image
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  // Funcion para llamar a la API de monedas
  Future<Map?> getCoins(XFile image) async {
    try {
      // url backend
      final url =
          Uri.parse('https://des.digitalonboarding.es/lazaro/coins/predict');
      final imageUploadRequest = http.MultipartRequest('POST', url);
      final file = await http.MultipartFile.fromPath('file', image.path);
      imageUploadRequest.files.add(file);
      final streamResponse =
          await imageUploadRequest.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode != 200) {
        print(response.statusCode);
        return null;
      }
      final decodedData = json.decode(response.body);
      return decodedData;
    } on TimeoutException catch (e) {
      print(e);
      return null;
    } on SocketException catch (e) {
      print(e);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Obtener imagen de la galeria
  void getImageGallery() async {
    _totalAmount = null;
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        _imageFile = pickedImage;
        _loading = true;
        _coins = null;
        setState(() {});
        if (_imageFile != null) {
          await getCoins(pickedImage).then((value) async {
            _coins = value;
            _loading = false;
            setState(() {});
            if (_coins != null) {
              _totalAmount = _coins!['total_amount'];
              _imageResult = imageFromBase64String(_coins!['encoded_image']);
              setState(() {});
              await Future.delayed(const Duration(milliseconds: 300), () {
                scrollDown();
                setState(() {});
              });
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Obtener imagen de la galeria
  void getImageCamera() async {
    _totalAmount = null;
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        _imageFile = pickedImage;
        _loading = true;
        _coins = null;
        setState(() {});
        if (_imageFile != null) {
          await getCoins(pickedImage).then((value) async {
            _coins = value;
            _loading = false;
            setState(() {});
            if (_coins != null) {
              _totalAmount = _coins!['total_amount'];
              _imageResult = imageFromBase64String(_coins!['encoded_image']);
              setState(() {});
              await Future.delayed(const Duration(milliseconds: 300), () {
                scrollDown();
                setState(() {});
              });
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void displayHelp(BuildContext context) {
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
                'Cuenta las monedas.\n\nDevuelve el valor total de las monedas detectadas',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                FontAwesomeIcons.coins,
                size: 70,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Contador de monedas',
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              displayHelp(context);
            },
            child: Container(
              color: Colors.black.withAlpha(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.coins,
                  size: 150,
                ),
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
            _loading ? const CircularProgressIndicator() : const SizedBox(),
            _totalAmount != null
                ? Column(
                    children: [
                      Text(processText(_coins!)),
                      Text(
                        '${_totalAmount.toString()} céntimos',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 32),
            _imageResult != null && _totalAmount != null
                ? _imageResult!
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.arrow_upward_outlined,
          size: 32,
        ),
        onPressed: () {
          scrollUp();
        },
      ),
    );
  }
}
