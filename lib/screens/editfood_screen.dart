import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({Key? key}) : super(key: key);

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _imageFile;
  bool _isAvailable = true; // Fake data for availability

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with fake data
    _nameController = TextEditingController(text: 'Burger');
    _descriptionController = TextEditingController(text: 'Delicious beef burger with cheese');
    _imageFile = null; // Set to null initially, will use default image if not picked
    _isAvailable = true; // Fake data
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle errors or plugin issues
      print('Error picking image: $e');
    }
  }

  void _deleteFoodItem() {
    // Handle delete functionality
    // Here you should handle the deletion of the food item
    print('Food item deleted');

    Navigator.pop(context); // Go back to the Food Management page
  }

  void _saveFoodItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedFoodItem = {
        'name': _nameController.text,
        'imageUrl': _imageFile?.path ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
        'description': _descriptionController.text,
        'isAvailable': _isAvailable,
      };

      // Handle saving the updated food item here
      print('Updated food item: $updatedFoodItem');

      Navigator.pop(context); // Close the page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF39c5c8),
        centerTitle: true,
        title: const Text(
          'Edit Food Item',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: _imageFile != null
                            ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                            : DecorationImage(
                          image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ),
                  ],
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _deleteFoodItem,
                    child: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveFoodItem,
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xFF39c5c8), // Text color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
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
