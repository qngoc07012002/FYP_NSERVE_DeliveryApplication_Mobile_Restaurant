import 'dart:convert';
import 'dart:io';
import 'package:deliveryapplication_mobile_restaurant/controllers/restaurant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../controllers/image_controller.dart';
import '../ultilities/Constant.dart';

class EditRestaurantProfilePage extends StatefulWidget {
  const EditRestaurantProfilePage({super.key});

  @override
  State<EditRestaurantProfilePage> createState() => _EditRestaurantProfilePageState();
}

class _EditRestaurantProfilePageState extends State<EditRestaurantProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? restaurantImage;
  bool isLoading = false;
  ImageController imageController = Get.put(ImageController());
  final RestaurantController restaurantController = Get.find();

  @override
  void initState() {
    super.initState();
    // Initialize with existing restaurant data
    _nameController.text = restaurantController.restaurantName.value;
    _descriptionController.text = restaurantController.restaurantDescription.value;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        restaurantImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Perform update logic
    print('Name: ${_nameController.text}');
    print('Description: ${_descriptionController.text}');
    print('Image Path: ${restaurantImage?.path}');
    if (restaurantImage != null){
      String? imgUrl = await imageController.uploadImage(restaurantImage!);
      restaurantController.restaurantImage.value = imgUrl!;
    }

    restaurantController.restaurantName.value = _nameController.text;
    restaurantController.restaurantDescription.value = _descriptionController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('jwt_token') ?? '';

    final response = await http.post(
      Uri.parse(Constant.UPDATE_RESTAURANT_URL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "restaurantName": _nameController.text,
        "description": _descriptionController.text,
        "imgUrl": restaurantController.restaurantImage.value,
      }),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['code'] == 1000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful!')),
        );

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong, please try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF39c5c8),
        title: const Text(
          'Edit Profile',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                      image: restaurantImage != null
                          ? DecorationImage(image: FileImage(restaurantImage!), fit: BoxFit.cover)
                          : (restaurantController.restaurantImage.value.isNotEmpty ?? false)
                          ? DecorationImage(
                        image: NetworkImage(
                            Constant.IMG_URL +  restaurantController.restaurantImage.value),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: restaurantImage == null && (restaurantController.restaurantImage.value.isEmpty ?? true)
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Restaurant Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39c5c8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
