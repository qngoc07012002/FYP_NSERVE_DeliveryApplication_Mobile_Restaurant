import 'package:deliveryapplication_mobile_restaurant/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../screens/homepage_screen.dart';
import '../ultilities/Constant.dart';

class UserController extends GetxController {

  Future<void> logout() async {
    final String token = await getToken();
    const url = Constant.LOGOUT_URL;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');

      Get.snackbar('Success', 'You have logged out successfully');
      Get.to(const LoginPage());
    } else {
      Get.snackbar('Error', 'Failed to logout: ${response.reasonPhrase}');
    }
  }

  Future<void> checkTokenValidity() async {
    final String token = await getToken();
    const url = Constant.INTROSPECT_URL;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final bool isValid = responseBody['result']['valid'];

      if (isValid) {
        Get.to(RestaurantDashboardPage());
      } else {
        print("Valid token");
        // Get.snackbar('Error', 'Token is no longer valid. Please log in again.');
        // Get.to(const LoginPage());
      }
    } else {
      // Get.snackbar('Error', 'Failed to check token validity: ${response.reasonPhrase}');
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }
}
