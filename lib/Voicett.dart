import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';





class Voicett extends StatefulWidget {

  const Voicett({Key? key}) : super(key: key);

  @override

  State<Voicett> createState() => _VoicettState();
}

class _VoicettState extends State<Voicett> {
  final SpeechToText _speechToText=SpeechToText();
  bool _speechEnabled=false;
  String _wordSpokken="";

  @override
  void initState(){
    super.initState();
    initSpeech();
  }
  void initSpeech() async{
    _speechEnabled= await _speechToText.initialize();
    setState(() {});
  }

  void _startListening()async{
    await _speechToText.listen(onResult:_onSpeechResult);
  }
  void _onSpeechResult(result) {
    setState(() {
      _wordSpokken="${result.recognizedWords}";
    });
  }
  Widget build(BuildContext context) {
    return  IconButton(
      icon: Icon(Icons.mic),
      onPressed: _startListening,
    );
  }
}
