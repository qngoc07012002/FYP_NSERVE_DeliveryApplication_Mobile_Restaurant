import 'dart:io';
import 'package:deliveryapplication_mobile_restaurant/controllers/restaurant_controller.dart';
import 'package:deliveryapplication_mobile_restaurant/controllers/user_controller.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../controllers/image_controller.dart';
import '../ultilities/Constant.dart';
import 'location_picker.dart';

class RestaurantRegisterPage extends StatefulWidget {
  const RestaurantRegisterPage({super.key});

  @override
  State<RestaurantRegisterPage> createState() => _RestaurantRegisterPageState();
}

class _RestaurantRegisterPageState extends State<RestaurantRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedCategory;
  String? location;
  double? latitude;
  double? longitude;
  File? restaurantImage;
  bool isLoading = false;
  final List<String> categories = ['Rice', 'Drink', 'Fast Food', 'Desserts'];
  final ImageController imageController = Get.put(ImageController());
  UserController userController = Get.find();


  void _pickLocation(String address, double lat, double lng) {
    setState(() {
      location = address;
      latitude = lat;
      longitude = lng;
    });
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
        _descriptionController.text.isEmpty ||
        location == null ||
        selectedCategory == null ||
        restaurantImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    // TODO: Handle submission logic
    print('Name: ${_nameController.text}');
    print('Description: ${_descriptionController.text}');
    print('Category: $selectedCategory');
    print('Location: $location');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Image Path: ${restaurantImage!.path}');

    setState(() {
      isLoading = true;
    });
    String? imgUrl = await imageController.uploadImage(restaurantImage!);
    if (imgUrl != null) {
      final response = await http.post(
        Uri.parse(Constant.REGISTER_RESTAURANT_URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phoneNumber": userController.phoneNumber.value,
          "restaurantName": _nameController.text.trim(),
          "description": _descriptionController.text.trim(),
          "location": {
            "latitude": latitude,
            "longitude": longitude,
            "address": location,
          },
          "category": selectedCategory,
          "imgUrl": imgUrl,
        }),
      );
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] == 1000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Get.to(VerificationPage(phoneNumber: userController.phoneNumber.value));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['result']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF39c5c8),
        title: const Text(
          'Register Restaurant',
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
                    ),
                    child: restaurantImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        restaurantImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),

                      ],
                    )
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
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPickerScreen(
                        onLocationPicked: _pickLocation,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity, // Đảm bảo full chiều rộng
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    location ?? 'Pick Location',
                    style: TextStyle(
                      color: location == null ? Colors.grey : Colors.black,
                    ),
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
                  minimumSize: const Size(double.infinity, 50), // Chiều rộng tối đa
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Register',
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
