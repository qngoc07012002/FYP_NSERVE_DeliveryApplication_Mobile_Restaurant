import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ultilities/Constant.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchOrders() async {
    String jwtToken = await getToken();

    final response = await http.get(
      Uri.parse(Constant.ORDER_RESTAURANT_URL),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> ordersData = data['result'];

      orders.value = ordersData.map((orderJson) => Order.fromJson(orderJson)).toList();
      isLoading.value = false;
    } else {
      isLoading.value = false;
      print('Failed to load orders: ${response.statusCode}');
    }
  }
}
