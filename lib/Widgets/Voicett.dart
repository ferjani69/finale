import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voicett extends StatefulWidget {
  final TextEditingController controller; // Add controller to update text
  const Voicett({Key? key, required this.controller}) : super(key: key);

  @override
  State<Voicett> createState() => _VoicettState();
}

class _VoicettState extends State<Voicett> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    var locales = await _speechToText.locales();
    var frenchLocale = locales.firstWhere(
            (locale) => locale.localeId.startsWith('fr_'),
        orElse: () => LocaleName('en_US', 'English')
    );

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: frenchLocale.localeId,
    );

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult( result) {
    setState(() {
      widget.controller.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _speechEnabled ? _startListening : null,
      onLongPressUp: _stopListening,
      child: Icon(
        Icons.mic,
        color: _isListening ? Colors.red : Colors.grey,
        size: 40.0,
      ),
    );
  }
}
