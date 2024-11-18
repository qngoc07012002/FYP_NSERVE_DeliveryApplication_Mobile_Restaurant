import 'dart:convert';
import 'package:deliveryapplication_mobile_restaurant/screens/orderdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/websocket_service.dart';
import '../ultilities/Constant.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <Order>[].obs;
  var currentOrder = Rx<Order?>(null);
  final WebSocketService _webSocketService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    subscribeReceiveOrder();
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

  void subscribeReceiveOrder(){
    _webSocketService.subscribe(
      '/queue/restaurant/order/123',
          (frame) async {
        if (frame.body != null) {
          Map<String, dynamic> jsonData = jsonDecode(frame.body!);
          print('Received message: $jsonData');
          if (jsonData['action'] == "CUSTOMER_REQUEST_ORDER"){
            showNotificationDialog(frame.body!);
          }
          if (jsonData['action'] == "DRIVER_ACCEPT_ORDER"){
            await fetchOrders();
           for (var order in orders){
            if (order.id == currentOrder.value?.id){
              currentOrder.value = order;
            }
           }
          }
        }
      },
    );
  }

  void showNotificationDialog(String message) {
    // Parse dữ liệu JSON để lấy thông tin món ăn
    Map<String, dynamic> jsonData = jsonDecode(message);
    List<dynamic> orderItems = jsonData['body']['orderItems'];

    Get.defaultDialog(
      title: "New Order",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị các món ăn và số lượng
            Column(
              children: orderItems.map<Widget>((item) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item['foodName'], style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text("x${item['quantity']}"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      barrierDismissible: false, // Không cho phép tắt dialog khi nhấn ra ngoài
      radius: 15,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nút Decline
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                sendOrderStatusUpdate(jsonData['body']['orderId'], "RESTAURANT_DECLINE_ORDER");
                Get.back();
              },
              child: const Text(
                "Decline",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Nút Accept
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                sendOrderStatusUpdate(jsonData['body']['orderId'], "RESTAURANT_ACCEPT_ORDER");
                print(jsonData['body']['orderId']);
                fetchOrderById(jsonData['body']['orderId']);
                Get.back();
                Get.to(OrderDetailPage());
              },
              child: const Text(
                "Accept",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void sendOrderStatusUpdate(String orderId, String action) {
    Map<String, dynamic> body = {
      'orderId': orderId,
      'action': action,
    };

    _webSocketService.sendMessage('/app/order/restaurant/', body);
  }

  Future<void> fetchOrderById(String orderId) async {
    String jwtToken = await getToken();

    final response = await http.get(
      Uri.parse('${Constant.ORDER_URL}/$orderId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Order order = Order.fromJson(data['result']);
      print(order);
      orders.add(order);
      currentOrder.value = order;
      isLoading.value = false;
    } else {
      isLoading.value = false;
      print('Failed to load order by ID: ${response.statusCode}');
    }
  }


}
