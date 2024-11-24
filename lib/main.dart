import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Time & Camera',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('native/time');
  String _currentTime = 'Час не отримано';
  XFile? _image;

  Future<void> _getCurrentTime() async {
    try {
      final String currentTime = await platform.invokeMethod('getCurrentTime');
      setState(() {
        _currentTime = currentTime;
      });
    } on PlatformException catch (e) {
      setState(() {
        _currentTime = "Помилка: '${e.message}'.";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Time & Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getCurrentTime,
              child: const Text('Отримати поточний час'),
            ),
            Text(
              _currentTime,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Зробити фото'),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(File(_image!.path)),
              ),
          ],
        ),
      ),
    );
  }
}
