import 'dart:convert';
import 'dart:io';
import 'package:deliveryapplication_mobile_restaurant/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ultilities/Constant.dart';
import 'package:http_parser/http_parser.dart';

class FoodController extends GetxController {
  var foodItems = <Food>[].obs;
  var isLoading = true.obs;
  var isCreating = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoods();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchFoods() async {
    try {
      isLoading(true);
      String jwtToken = await getToken();


      final url = Uri.parse(Constant.FOOD_URL);
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $jwtToken",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["code"] == 1000) {
          foodItems.value = (data["result"] as List).map((item) {
            return Food(
              item["id"],
              item["name"],
              item["imgUrl"],
              item["description"],
              item["status"] == "ACTIVE",
              item["price"],
            );
          }).toList();
        }
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching foods: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> updateFoodStatus(String foodId, bool isAvailable) async {
    try {
      String token = await getToken();


      final url = Uri.parse('${Constant.FOOD_URL}/$foodId/status');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': isAvailable ? 'ACTIVE' : 'INACTIVE'}),
      );

      if (response.statusCode == 200) {
        print('Status updated successfully');

      } else {
        print('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> createFood(String name, String description, String imgUrl, double price) async {
    isCreating(true);
    try {
      String token = await getToken();

      final url = Uri.parse(Constant.FOOD_URL);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'imgUrl': imgUrl,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["code"] == 1000) {
          print('Food created successfully: ${data["result"]["id"]}');

          foodItems.add(Food(
            data["result"]["id"],
            data["result"]["name"],
            data["result"]["imgUrl"],
            data["result"]["description"],
            data["result"]["status"] == "ACTIVE",
            data["result"]["price"],
          ));
        } else {
          print('Failed to create food: ${data["message"]}');
        }
      } else {
        print('Failed to create food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating food: $e');
    } finally {
      isCreating(false); // Reset loading state
    }
  }

  Future<void> updateFood(String id, String name, String description, String imgUrl, double price) async {
    try {
      String token = await getToken();

      final url = Uri.parse(Constant.FOOD_URL+"/$id");
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'imgUrl': imgUrl,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["code"] == 1000) {
          print('Food updated successfully: ${data["result"]["id"]}');
          Food food = Food(data["result"]["id"],
            data["result"]["name"],
            data["result"]["imgUrl"],
            data["result"]["description"],
            data["result"]["status"] == "ACTIVE",
            data["result"]["price"],);

          int index = foodItems.indexWhere((food) => food.id == data["result"]["id"]);
          foodItems[index] = food;
          update();

        } else {
          print('Failed to update food: ${data["message"]}');
        }
      } else {
        print('Failed to update food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating food: $e');
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      String token = await getToken();

      final url = Uri.parse(Constant.FOOD_URL + "/$id");
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["code"] == 1000) {
          int index = foodItems.indexWhere((food) => food.id == id);
          foodItems.removeAt(index);
        } else {
          print('Failed to delete food: ${data["message"]}');
        }
      }
    } catch (e) {
      print('Error updating food: $e');
    }
  }
}
