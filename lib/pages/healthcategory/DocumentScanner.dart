import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DocumentScanner extends StatefulWidget {
  @override
  _DocumentScannerState createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  bool _isProcessing = false;
  String _scannedText = '';
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _scanDocument() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Capture image
      final XFile image = await _controller!.takePicture();
      
      // Get temporary directory to save the image
      final Directory tempDir = await getTemporaryDirectory();
      final String imagePath = join(tempDir.path, '${DateTime.now()}.jpg');
      
      // Copy image to temporary directory
      File(image.path).copySync(imagePath);

      // Initialize text recognizer
      final TextRecognizer textRecognizer = TextRecognizer();
      
      // Process the image
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _scannedText = recognizedText.text;
        _isProcessing = false;
      });

      // Clean up
      textRecognizer.close();
      
    } catch (e) {
      print('Error scanning document: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: CameraPreview(_controller!),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_isProcessing)
                      CircularProgressIndicator()
                    else
                      Text(_scannedText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _scanDocument,
        child: Icon(Icons.camera),
      ),
    );
  }
}