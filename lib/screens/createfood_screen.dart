import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';
import '../models/food_model.dart';
import '../controllers/food_controller.dart';

class CreateFoodPage extends StatefulWidget {
  const CreateFoodPage({Key? key}) : super(key: key);

  @override
  State<CreateFoodPage> createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FoodController foodController = Get.put(FoodController());
  final ImageController imageController = Get.put(ImageController());

  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveFoodItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFile != null) {
        String? imgUrl = await imageController.uploadImage(_imageFile!);
        imageController.isLoading(false);
        if (imgUrl != null) {
          double? price = double.tryParse(_priceController.text);
         foodController.createFood(_nameController.text, _descriptionController.text, imgUrl, price!);
          Navigator.pop(context);
        }
      } else {
        Get.snackbar("Error", "Please select an image", snackPosition: SnackPosition.BOTTOM);
        print('Please select an image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Food Item', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      image: _imageFile != null
                          ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imageFile == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                        Text("Add Image", style: TextStyle(color: Colors.grey)),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (USD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: foodController.isCreating.value ? null : _saveFoodItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39c5c8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: imageController.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Create',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
