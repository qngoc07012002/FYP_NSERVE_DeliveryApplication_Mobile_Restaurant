import 'package:deliveryapplication_mobile_restaurant/controllers/order_controller.dart';
import 'package:deliveryapplication_mobile_restaurant/controllers/restaurant_controller.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/login_screen.dart';
import 'package:deliveryapplication_mobile_restaurant/services/websocket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controllers/user_controller.dart';

void main() {
  Get.put(WebSocketService());
  Get.put(RestaurantController());
  Get.put(OrderController());
  runApp(GetMaterialApp(
    home: RestaurantDashboardPage(),
  ));
}