import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class ImageCaptionScreen extends StatefulWidget {
  const ImageCaptionScreen({Key? key}) : super(key: key);

  @override
  State<ImageCaptionScreen> createState() => _ImageCaptionScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _ImageCaptionScreenState extends State<ImageCaptionScreen> {
  // Class private variables
  final translator = GoogleTranslator();
  final ScrollController _scrollController = ScrollController();
  double _currentSliderValue = 40;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageRaw;
  bool _loading = false;
  List? _predictions;
  Translation? _textoTraducido;

  void scrollUp() async {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  void scrollDown() async {
    _scrollController.animateTo(380,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  // Predictions
  void getImageGallery() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        File imageFile = File(pickedImage.path);
        Uint8List imageRaw = await imageFile.readAsBytes();
        _imageFile = pickedImage;
        _imageRaw = imageRaw;
        _loading = true;
        _predictions = null;
        _textoTraducido = null;
        setState(() {});
        if (_imageFile != null && _imageRaw != null) {
          await getPredictions().then((value) async {
            _predictions = value;
            _loading = false;
            setState(() {});
            if (_predictions != null) {
              if (_predictions!.isNotEmpty) {
                _textoTraducido = await translator
                    .translate(_predictions![0]['caption'], to: 'es');
                setState(() {});
                if (_textoTraducido != null) {
                  _newVoiceText = _textoTraducido.toString();
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 300), () {
                    scrollDown();
                    setState(() {});
                    _speak();
                    setState(() {});
                  });
                }
              }
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List?> getPredictions() async {
    try {
      var url = Uri.parse('http://192.168.9.12:5000/model/predict');
      var imageUploadRequest = http.MultipartRequest('POST', url);
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        _imageRaw!,
        filename: 'test.jpg', // use the real name if available, or omit
        contentType: MediaType('image', 'jpg'),
      );
      imageUploadRequest.files.add(multipartFile);
      final streamResponse =
          await imageUploadRequest.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final decodedData = json.decode(response.body);
      return decodedData['predictions'];
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

  // TTS
  late FlutterTts flutterTts;
  String? language = 'es-ES';
  String? engine;
  double volume = 0.7;
  double pitch = 1.0;
  double rate = 0.55;
  bool isCurrentLanguageInstalled = true;
  String? _newVoiceText;
  TtsState ttsState = TtsState.stopped;
  File image2 = File('assets/logo.png');

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    _getDefaultEngine();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setLanguage('es-ES');
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {}
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Display help
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
                'Haz una foto, o selecciona una imagen de la galería.\n\nAutomaticamente describe el entorno que te rodea.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                FontAwesomeIcons.landmark,
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
  void initState() {
    super.initState();
    initTts();
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
          'Descripción del entorno',
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
                  FontAwesomeIcons.landmark,
                  size: 150,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.camera_alt_outlined, size: 32),
              onPressed: () {},
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
            // const SizedBox(height: 32),
            // loading ? const CircularProgressIndicator() : const SizedBox(),
            // if (predictions != null)
            //   predictions!.isNotEmpty ? getTextWidgets(captions!) : Container(),
            // const SizedBox(height: 32),
            // imageFile != null && !loading
            //     ? Image.file(File(imageFile!.path))
            //     : Container(),
            const SizedBox(height: 32),
            _loading ? const CircularProgressIndicator() : const SizedBox(),
            _textoTraducido != null
                ? Text(_textoTraducido.toString())
                : const SizedBox(),
            const SizedBox(height: 32),
            _imageFile != null && _textoTraducido != null
                ? Image.file(File(_imageFile!.path))
                : const SizedBox(),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Container(
          child: _playStopSection(context),
        )
      ],
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

  Widget _playStopSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCustomButton(Colors.white, Icons.play_arrow, 'Play', _speak),
            _buildCustomButton(Colors.white, Icons.stop, 'Stop', _stop),
          ],
        ),
        _rateSlider(),
        // _sizeSlider(),
      ],
    );
  }

  Material _buildCustomButton(
      Color color, IconData icon, String label, Function func) {
    return Material(
      child: InkWell(
        onTap: () => func(),
        child: Container(
          padding: const EdgeInsets.only(right: 16, top: 8),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rateSlider() {
    return Slider(
      value: rate,
      divisions: 10,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.1,
      max: 1.0,
      label: "Velocidad",
    );
  }

  Widget _sizeSlider() {
    return Slider(
      value: _currentSliderValue,
      divisions: 10,
      min: 20,
      max: 60,
      label: 'Tamaño: ${_currentSliderValue.round().toString()}',
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
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
