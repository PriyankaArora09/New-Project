import 'package:demo/navigator/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return height < 0
        ? const SizedBox.shrink()
        : ScreenUtilInit(
            designSize: Size(width, height),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                routerDelegate: Routes.router.routerDelegate,
                routeInformationProvider:
                    Routes.router.routeInformationProvider,
                routeInformationParser: Routes.router.routeInformationParser,
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark(),
                themeMode: ThemeMode.dark,
                scrollBehavior: MyBehavior(),
              );
            },
          );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// Sahayak - AI Teaching Assistant Sample Flutter App
// Basic structure with Gemini text generation + voice input
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() {
//   runApp(SahayakApp());
// }

// class SahayakApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sahayak AI Assistant',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _response = "";
//   bool _isLoading = false;
//   stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;

//   Future<void> _sendToGemini(String prompt) async {
//     const apiKey =
//         'AIzaSyD9jep8eRqrf6GhoI6pJnTwoHo3Inf0XRM'; // Replace with your Gemini API key
//     setState(() => _isLoading = true);

//     final url = Uri.parse(
//         'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

//     final body = {
//       "contents": [
//         {
//           "parts": [
//             {"text": prompt}
//           ]
//         }
//       ]
//     };

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );

//     final jsonData = json.decode(response.body);
//     final text = jsonData['candidates']?[0]['content']['parts'][0]['text'] ??
//         'No response.';

//     setState(() {
//       _response = text;
//       _isLoading = false;
//     });
//   }

//   Future<void> _startListening() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(onResult: (result) {
//         setState(() => _controller.text = result.recognizedWords);
//       });
//     }
//   }

//   void _stopListening() {
//     setState(() => _isListening = false);
//     _speech.stop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sahayak AI Assistant"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: "Ask something in your language",
//                 suffixIcon: IconButton(
//                   icon: Icon(_isListening ? Icons.stop : Icons.mic),
//                   onPressed: _isListening ? _stopListening : _startListening,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => _sendToGemini(_controller.text),
//               child: const Text("Generate Content"),
//             ),
//             const SizedBox(height: 24),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : Expanded(
//                     child: SingleChildScrollView(
//                       child: Text(
//                         _response,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Sahayak - AI Teaching Assistant Sample Flutter App
// Extended version with Gemini text generation, voice input, worksheet/image generation, and image input

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(SahayakApp());
// }

// class SahayakApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sahayak AI Assistant',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _response = "";
//   bool _isLoading = false;
//   stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   File? _imageFile;
//   String _selectedLanguage = 'English';
//   String _selectedGrade = 'Grade 1';

//   final List<String> _languages = [
//     'English',
//     'Hindi',
//     'Marathi',
//     'Kannada',
//     'Tamil'
//   ];
//   final List<String> _grades = [
//     'Grade 1',
//     'Grade 2',
//     'Grade 3',
//     'Grade 4',
//     'Grade 5'
//   ];

//   Future<void> _sendToGemini(String prompt) async {
//     const apiKey =
//         'AIzaSyD9jep8eRqrf6GhoI6pJnTwoHo3Inf0XRM'; // Replace with your API key
//     setState(() => _isLoading = true);

//     final uri = Uri.parse(
//         'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

//     List<Map<String, dynamic>> parts = [];

//     if (_imageFile != null) {
//       final imageBytes = await _imageFile!.readAsBytes();
//       final base64Image = base64Encode(imageBytes);

//       parts.add({
//         "inlineData": {
//           "mimeType": "image/jpeg",
//           "data": base64Image,
//         }
//       });
//     }

//     parts.add({
//       "text":
//           "$prompt\nGenerate content suitable for $_selectedGrade in $_selectedLanguage."
//     });

//     final body = {
//       "contents": [
//         {
//           "parts": parts,
//         }
//       ]
//     };

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );

//     final jsonData = json.decode(response.body);

//     print(jsonData);
//     final text = jsonData['candidates']?[0]['content']['parts'][0]['text'] ??
//         'No response.';

//     setState(() {
//       _response = text;
//       _isLoading = false;
//     });
//   }

//   Future<void> _startListening() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(onResult: (result) {
//         setState(() => _controller.text = result.recognizedWords);
//       });
//     }
//   }

//   void _stopListening() {
//     setState(() => _isListening = false);
//     _speech.stop();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sahayak AI Assistant"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Language Selection
//             DropdownButton<String>(
//               value: _selectedLanguage,
//               onChanged: (val) => setState(() => _selectedLanguage = val!),
//               items: _languages
//                   .map((lang) => DropdownMenuItem(
//                         value: lang,
//                         child: Text(lang),
//                       ))
//                   .toList(),
//             ),
//             // Grade Selection
//             DropdownButton<String>(
//               value: _selectedGrade,
//               onChanged: (val) => setState(() => _selectedGrade = val!),
//               items: _grades
//                   .map((grade) => DropdownMenuItem(
//                         value: grade,
//                         child: Text(grade),
//                       ))
//                   .toList(),
//             ),

//             // Prompt Text Field with Voice
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: "Ask or describe something...",
//                 suffixIcon: IconButton(
//                   icon: Icon(_isListening ? Icons.stop : Icons.mic),
//                   onPressed: _isListening ? _stopListening : _startListening,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Upload Image
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text("Upload Image (optional)"),
//             ),
//             const SizedBox(height: 8),

//             // Send Prompt
//             ElevatedButton(
//               onPressed: () => _sendToGemini(_controller.text),
//               child: const Text("Generate Response"),
//             ),
//             const SizedBox(height: 24),

//             // Output Display
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : Expanded(
//                     child: SingleChildScrollView(
//                       child: Text(
//                         _response,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
