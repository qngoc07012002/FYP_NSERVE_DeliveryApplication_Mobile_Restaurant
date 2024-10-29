import 'package:deliveryapplication_mobile_restaurant/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_restaurant/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const GetMaterialApp(
    home: RestaurantDashboardPage(),
  ));
}