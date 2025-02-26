import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ultilities/Constant.dart';

class RestaurantController extends GetxController {
  var isLoading = true.obs;
  var isOpen = true.obs;
  var restaurantName = ''.obs;
  var restaurantDescription = ''.obs;
  var restaurantImage = ''.obs;
  var restaurantRating = 0.0.obs;
  var restaurantId = ''.obs;
  var balance = 0.0.obs;
  var revenue = 0.0.obs;
  var orderCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantInfo();
    fetchStatistics();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchRestaurantInfo() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.setString('jwt_token', Constant.JWT);

    String? jwtToken = await getToken();


    final response = await http.get(
      Uri.parse(Constant.RESTAURANT_INFO_URL),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      restaurantId.value = data['id'];
      restaurantName.value = data['restaurantName'];
      restaurantDescription.value = data['description'];
      restaurantImage.value = data['imgUrl'];
      restaurantRating.value = data['rating'];
      isOpen.value = data['status'] == 'ONLINE';
      balance.value = data['balance'];
      isLoading.value = false; // Data has been loaded

    } else {
      isLoading.value = false; // Data loading failed

    }
  }

  Future<void> fetchStatistics() async {
    String? jwtToken = await getToken();

    final response = await http.get(
      Uri.parse(Constant.STATISTIC_URL),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      revenue.value = data['result']['revenue'];
      orderCount.value = data['result']['orderCount'];
    } else {
      print('Failed to fetch statistics: ${response.statusCode}');
    }
  }

  Future<void> updateRestaurantStatus(bool isOpenRestaurant) async {
    String token = await getToken();

    final url = Uri.parse('${Constant.RESTAURANT_URL}/$restaurantId/status');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': isOpenRestaurant ? 'ONLINE' : 'OFFLINE'}),
    );

    if (response.statusCode == 200) {
      print('Status updated successfully');
    } else {
      print('Failed to update status: ${response.statusCode}');
    }
  }

}
