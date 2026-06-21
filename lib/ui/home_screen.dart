import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();
  Map<String, String> languageMap = {
    'en-US': 'English',
    'ur-PK': 'Urdu',
    'hi-IN': 'Hindi',
    'es-ES': 'Spanish',
    'fr-FR': 'French',
    'de-DE': 'German',
    'zh-CN': 'Chinese',
    'ja-JP': 'Japanese',
    'ko-KR': 'Korean',
    'it-IT': 'Italian',
    'pt-PT': 'Portuguese',
    'ru-RU': 'Russia',
    'vi-VN': 'Vietnam',
  };

  List<String> languages = [];
  String? selectedLanguage;
  double pitch = 1.0;
  double speechRate = 0.5;
  double volume = 0.8;
  Future<void> initTts() async {
    List<dynamic> availableLanguages = await flutterTts.getLanguages;
    languages = availableLanguages
        .where((language) => languageMap.keys.contains(language))
        .map((language) => language as String)
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? 'vi-VN');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(text);
  }

  Future<void> save(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? 'en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speechRate);
    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    await flutterTts.synthesizeToFile(text, 'tts_audio_$timestamp.mp3');
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> pause() async {
    await flutterTts.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text to speech')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Enter the text",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await speak(textController.text);
                        },
                        icon: Icon(Icons.play_arrow, color: Colors.green),
                      ),
                      Text('Play', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await stop();
                        },
                        icon: Icon(Icons.stop, color: Colors.redAccent),
                      ),
                      Text('Stop', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await pause();
                        },
                        icon: Icon(Icons.pause, color: Colors.indigo),
                      ),
                      Text('Pause', style: TextStyle(color: Colors.indigo)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButton<String>(
                  hint: Text("Select lanuage"),
                  items: languages
                      .map(
                        (language) => DropdownMenuItem<String>(
                          value: language,
                          child: Text(languageMap[language]!),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text("Volume: ${volume.toStringAsFixed(1)}"),
              Slider(
                activeColor: Colors.green,
                min: 0.0,
                max: 1.0,
                value: volume,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Pitch: ${pitch.toStringAsFixed(1)}"),
              Slider(
                activeColor: Colors.redAccent,
                min: 0.5,
                max: 2.0,
                value: pitch,
                onChanged: (value) {
                  setState(() {
                    pitch = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Speech Rate: ${speechRate.toStringAsFixed(1)}"),
              Slider(
                activeColor: Colors.indigo,
                min: 0.0,
                max: 1.0,
                value: speechRate,
                onChanged: (value) {
                  setState(() {
                    speechRate = value;
                  });
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await save(textController.text);
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
