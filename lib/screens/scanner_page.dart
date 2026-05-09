import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScannerPage extends StatefulWidget {
  static const routeName = '/scanner';
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile; 
  bool _loading = false;
  Map<String, dynamic>? _topPrediction; 

  final String _project = 'waste-segregation-yrfaz'; 
  final String _version = '1'; 
  final String _apiKey = 'RNCpup3CKFY5xQzHYZqb'; 

  String get _url =>
      'https://detect.roboflow.com/$_project/$_version?api_key=$_apiKey';

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 70);
    if (picked == null) return;
    setState(() {
      _imageFile = File(picked.path);
      _topPrediction = null; 
    });
    _sendToModel(_imageFile!);
  }

  Future<void> _sendToModel(File image) async {
    setState(() => _loading = true);
    try {
      
      final imageBytes = await image.readAsBytes();
      
      String base64Image = base64Encode(imageBytes);

     
      final response = await http.post(
        Uri.parse('$_url&name=image.jpg'), 
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: base64Image,
      );

      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['predictions'] != null && data['predictions'].isNotEmpty) {
          
          final predictions = List<Map<String, dynamic>>.from(data['predictions']);
          predictions.sort((a, b) => b['confidence'].compareTo(a['confidence']));
          setState(() {
            _topPrediction = predictions.first;
          });
        } else {
           setState(() {
             _topPrediction = {'class': 'No waste detected', 'confidence': 0.0};
           });
        }
      } else {
        throw Exception('Failed to get prediction: ${response.body}');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to model: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'AI Waste Scanner',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : const Center(child: Text('Your image will appear here')),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_topPrediction != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Prediction Result',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Chip(
                          label: Text(
                            _topPrediction!['class'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Confidence: ${(_topPrediction!['confidence'] * 100).toStringAsFixed(1)}%',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
