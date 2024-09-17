import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateFoodPage extends StatefulWidget {
  const CreateFoodPage({Key? key}) : super(key: key);

  @override
  State<CreateFoodPage> createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  bool _isAvailable = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveFoodItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final newFoodItem = FoodItem(
        _nameController.text,
        _imageFile?.path ?? '',
        _descriptionController.text,
        _isAvailable,
      );

      // Handle saving the new food item here
      print('New food item: $newFoodItem');

      Navigator.pop(context); // Close the page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Food Item',
          style: TextStyle(
            color: Colors.white, // White text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        centerTitle: true, // Center the title
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveFoodItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150, // Set fixed height for image
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    image: _imageFile != null
                        ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey,
                  )
                      : null,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Available'),
                  Switch(
                    value: _isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeColor: const Color(0xFF39c5c8),
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red[200],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItem {
  String name;
  String imageUrl;
  String? description;
  bool isAvailable;

  FoodItem(this.name, this.imageUrl, this.description, this.isAvailable);

  @override
  String toString() {
    return 'FoodItem(name: $name, imageUrl: $imageUrl, description: $description, isAvailable: $isAvailable)';
  }
}

void main() {
  runApp(const MaterialApp(
    home: CreateFoodPage(),
  ));
}
