import 'package:flutter/material.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  static const int sampleRate = 16000;

  final VoskFlutterPlugin _vosk = VoskFlutterPlugin.instance();
  final ModelLoader _modelLoader = ModelLoader();

  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  bool _isListening = false;
  String _status = 'Loading Vosk model...';

  @override
  void initState() {
    super.initState();
    _initializeVosk();
  }

  Future<void> _initializeVosk() async {
    try {
      final modelPath = await _modelLoader.loadFromAssets(
        'assets/models/vosk-model-small-en-us-0.15.zip',
      );

      final model = await _vosk.createModel(modelPath);

      final recognizer = await _vosk.createRecognizer(
        model: model,
        sampleRate: sampleRate,
      );

      final speechService = await _vosk.initSpeechService(recognizer);

      if (!mounted) return;

      setState(() {
        _model = model;
        _recognizer = recognizer;
        _speechService = speechService;
        _status = 'Vosk is ready!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Error:\n$e';
      });
    }
  }

  Future<void> _startRecognition() async {
    if (_speechService == null) return;

    try {
      await _speechService!.start();

      if (!mounted) return;

      setState(() {
        _isListening = true;
        _status = 'Listening... Speak now';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Microphone error:\n$e';
      });
    }
  }

  Future<void> _stopRecognition() async {
    if (_speechService == null) return;

    try {
      await _speechService!.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
        _status = 'Recognition stopped';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Stop error:\n$e';
      });
    }
  }

  @override
  void dispose() {
    _speechService?.dispose();
    _recognizer?.dispose();
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = _speechService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recognition'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: service == null
              ? Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vosk Speech Recognition',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Partial result:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<String>(
                      stream: service.onPartial(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Final result:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<String>(
                      stream: service.onResult(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isListening
                          ? _stopRecognition
                          : _startRecognition,
                      child: Text(
                        _isListening
                            ? 'Stop Recognition'
                            : 'Start Voice Recognition',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}