import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Thêm dòng này
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart'; // Thêm dòng này

class UploadFilePage extends StatefulWidget {
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image selected. Please select an image first.'),
      ));
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8080/nserve/files/upload'),
    );

    // Lấy loại tệp hình ảnh
    final mimeType = lookupMimeType(_image!.path);

    // Thêm tệp hình ảnh vào request với loại tệp
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _image!.path,
      contentType: MediaType.parse(mimeType!),
    ));

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      print('Response status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');

      final data = jsonDecode(responseBody.body);

      if (data['code'] == 1000) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File uploaded successfully: ${data['result']}'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${data['message']}'),
        ));
      }
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Upload failed.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
              _image!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
