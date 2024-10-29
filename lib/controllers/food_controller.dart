import 'dart:convert';
import 'package:deliveryapplication_mobile_restaurant/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ultilities/Constant.dart';

class FoodController extends GetxController {
  var foodItems = <Food>[].obs;
  var isLoading = true.obs;

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
      jwtToken = Constant.JWT;

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
              "${Constant.BACKEND_URL}${item["imgUrl"]}",
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
      token = Constant.JWT;

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
}
