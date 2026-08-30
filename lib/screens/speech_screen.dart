import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class SpeechScreen extends StatefulWidget {
  final Function(String) onResult;

  const SpeechScreen({
    super.key,
    required this.onResult,
  });

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

  StreamSubscription<String>? _resultSubscription;
  StreamSubscription<String>? _partialSubscription;

  bool _isListening = false;
  bool _isDisposing = false;
  bool _resultSent = false;

  String _status = 'Loading Vosk model...';
  String _partialText = '';
  String _finalText = '';

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

      if (_isDisposing) return;

      _model = await _vosk.createModel(modelPath);

      if (_isDisposing) return;

      _recognizer = await _vosk.createRecognizer(
        model: _model!,
        sampleRate: sampleRate,
      );

      if (_isDisposing) return;

      /*
       * IMPORTANT:
       * Create SpeechService only once for this screen.
       */
      _speechService = await _vosk.initSpeechService(_recognizer!);

      if (_isDisposing) return;

      if (!mounted) return;

      setState(() {
        _status = 'Vosk is ready!';
      });

      _setupResultListener();
    } catch (e) {
      if (!mounted || _isDisposing) return;

      setState(() {
        _status = 'Error:\n$e';
      });
    }
  }

  void _setupResultListener() {
    final service = _speechService;

    if (service == null) return;

    _resultSubscription?.cancel();

    _resultSubscription = service.onResult().listen(
      (result) {
        if (!mounted || _isDisposing) return;

        final text = _extractText(result);

        if (text.isEmpty) return;

        _resultSent = true;

        setState(() {
          _finalText = text;
          _partialText = '';
          _isListening = false;
          _status = 'Speech recognized';
        });

        /*
         * Send recognized text back to EmergencyScreen.
         */
        widget.onResult(text);
      },
      onError: (error) {
        if (!mounted || _isDisposing) return;

        setState(() {
          _status = 'Recognition error:\n$error';
          _isListening = false;
        });
      },
    );
  }

  void _setupPartialListener() {
    final service = _speechService;

    if (service == null) return;

    _partialSubscription?.cancel();

    _partialSubscription = service.onPartial().listen(
      (result) {
        if (!mounted || _isDisposing) return;

        final text = _extractText(result);

        setState(() {
          _partialText = text;
        });
      },
      onError: (_) {},
    );
  }

  String _extractText(String result) {
    try {
      final cleaned = result.trim();

      if (cleaned.isEmpty) {
        return '';
      }

      final match =
          RegExp(r'"text"\s*:\s*"([^"]*)"').firstMatch(cleaned);

      if (match != null) {
        return match.group(1)?.trim() ?? '';
      }

      final partialMatch =
          RegExp(r'"partial"\s*:\s*"([^"]*)"').firstMatch(cleaned);

      if (partialMatch != null) {
        return partialMatch.group(1)?.trim() ?? '';
      }

      return cleaned;
    } catch (_) {
      return result.trim();
    }
  }

  Future<void> _startRecognition() async {
    final service = _speechService;

    if (service == null) {
      return;
    }

    if (_isListening || _isDisposing) {
      return;
    }

    try {
      _resultSent = false;
      _finalText = '';
      _partialText = '';

      _setupPartialListener();

      await service.start();

      if (!mounted || _isDisposing) return;

      setState(() {
        _isListening = true;
        _status = 'Listening... Speak now';
      });
    } catch (e) {
      if (!mounted || _isDisposing) return;

      setState(() {
        _isListening = false;
        _status = 'Microphone error:\n$e';
      });
    }
  }

  Future<void> _stopRecognition() async {
    final service = _speechService;

    if (service == null || !_isListening || _isDisposing) {
      return;
    }

    try {
      await service.stop();

      if (!mounted || _isDisposing) return;

      setState(() {
        _isListening = false;
        _status = _finalText.isEmpty
            ? 'Recognition stopped'
            : 'Speech recognized';
      });
    } catch (e) {
      if (!mounted || _isDisposing) return;

      setState(() {
        _isListening = false;
        _status = 'Stop error:\n$e';
      });
    }
  }

  Future<void> _closeScreen() async {
    if (_isDisposing) return;

    _isDisposing = true;

    try {
      if (_isListening && _speechService != null) {
        await _speechService!.stop();
      }
    } catch (_) {}

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _isDisposing = true;

    _resultSubscription?.cancel();
    _partialSubscription?.cancel();

    /*
     * Do NOT call SpeechService.dispose() here.
     *
     * vosk_flutter keeps the native SpeechService instance.
     * Disposing it here can leave the Android side in a state where
     * the next SpeechScreen gets:
     *
     * "SpeechService instance already exist"
     */

    _speechService = null;

    _recognizer?.dispose();
    _recognizer = null;

    _model?.dispose();
    _model = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = _speechService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recognition'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _closeScreen,
        ),
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
                      'Live speech:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _partialText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Recognized text:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _finalText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton.icon(
                      onPressed: _isListening
                          ? _stopRecognition
                          : _startRecognition,
                      icon: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                      ),
                      label: Text(
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
