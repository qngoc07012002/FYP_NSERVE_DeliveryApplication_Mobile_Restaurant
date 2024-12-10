import 'package:deliveryapplication_mobile_restaurant/controllers/food_controller.dart';
import 'package:deliveryapplication_mobile_restaurant/models/food_model.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/createfood_screen.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/editfood_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ultilities/Constant.dart';

class FoodManagementPage extends StatefulWidget {
  @override
  _FoodManagementPageState createState() => _FoodManagementPageState();
}

class _FoodManagementPageState extends State<FoodManagementPage> {
  final FoodController controller = Get.put(FoodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF39c5c8),
          title: const Text(
            'Food Management',
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.foodItems.length,
          itemBuilder: (context, index) {
            final foodItem = controller.foodItems[index];
            return FoodCard(
              foodItem: foodItem,
              index: index,
              controller: controller,
              onSwitchChanged: (bool value) {
                setState(() {
                  controller.foodItems[index].isAvailable = value;
                });
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF39c5c8),
        onPressed: () {
          Get.to(() => CreateFoodPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}



class FoodCard extends StatelessWidget {
  final Food foodItem;
  final int index;
  final FoodController controller;
  final ValueChanged<bool> onSwitchChanged;

  FoodCard({required this.foodItem, required this.index, required this.controller, required this.onSwitchChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: foodItem.isAvailable ? Colors.white : Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                Constant.IMG_URL + foodItem.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/food_image.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: foodItem.isAvailable
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${foodItem.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39c5c8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    foodItem.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: foodItem.isAvailable
                          ? Colors.black87
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: foodItem.isAvailable,
                  onChanged: (bool value) async {
                    await controller.updateFoodStatus(foodItem.id!, value);
                    onSwitchChanged(value); // gọi onSwitchChanged để cập nhật trạng thái
                  },
                  activeColor: const Color(0xFF39c5c8),
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red[200],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Get.to(() => EditFoodPage(foodItem: foodItem,));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

