import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controllers/food_controller.dart';
import '../controllers/image_controller.dart';
import '../models/food_model.dart';
import '../ultilities/Constant.dart';

class EditFoodPage extends StatefulWidget {
  final Food foodItem;

  const EditFoodPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String _imgUrl;
  late String _id;
  File? _imageFile;
  final FoodController foodController = Get.put(FoodController());
  final ImageController imageController = Get.put(ImageController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodItem.name);
    _descriptionController = TextEditingController(text: widget.foodItem.description);
    _priceController = TextEditingController(text: widget.foodItem.price.toString());
    _imgUrl = widget.foodItem.imageUrl;
    _id = widget.foodItem.id!;
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
      print('Error picking image: $e');
    }
  }

  void _deleteFoodItem() {
    print('Food item deleted');
    foodController.deleteFood(_id);
    Navigator.pop(context);
  }

  Future<void> _saveFoodItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFile != null) {
        _imgUrl = (await imageController.uploadImage(_imageFile!))!;
        imageController.isLoading(false);
      }
      double? price = double.tryParse(_priceController.text);
      foodController.updateFood(
          _id,
          _nameController.text,
          _descriptionController.text, _imgUrl,
          price!);
      print('Updated food item: ${_imgUrl} ');
      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF39c5c8),
        title: const Text(
          'Edit Food',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 80.0,
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView here
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
                            Constant.IMG_URL + _imgUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _pickImage,
                        iconSize: 30,
                        color: const Color(0xFF39c5c8),
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
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$', // Add currency prefix
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() {
                return imageController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _deleteFoodItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Delete'),
                    ),
                    ElevatedButton(
                      onPressed: _saveFoodItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39c5c8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
