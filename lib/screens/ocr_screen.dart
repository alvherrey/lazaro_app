import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({Key? key}) : super(key: key);

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _OcrScreenState extends State<OcrScreen> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  String scannedText = '';
  bool loading = false;
  double _currentSliderValue = 40;

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

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  void getImageGallery() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        loading = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      loading = false;
      imageFile = null;
      setState(() {});
      scannedText = 'Error al escanear';
    }
  }

  void getImageCamera() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        loading = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      loading = false;
      imageFile = null;
      setState(() {});
      scannedText = 'Error al escanear';
    }
  }

  void getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + '\n';
      }
    }
    _newVoiceText = scannedText;
    loading = false;
    await Future.delayed(const Duration(milliseconds: 300), () {
      scrollDown();
      setState(() {});
    });
    setState(() {});
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
                'Haz una foto, o selecciona una imagen de la galería.\n\nAutomaticamente lee el contenido del texto.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                Icons.document_scanner,
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

  void scrollDown() async {
    _scrollController.animateTo(400,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

  void scrollUp() async {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
  }

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
          'Lectura de documentos',
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
                  Icons.document_scanner,
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
            loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        scannedText,
                        style: TextStyle(
                          fontSize: _currentSliderValue,
                        ),
                      ),
                    ],
                  ),
            imageFile != null && !loading
                ? Image.file(File(imageFile!.path))
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
        _sizeSlider(),
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
}
