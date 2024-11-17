import 'package:deliveryapplication_mobile_restaurant/screens/orderdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../controllers/order_controller.dart'; // Import OrderController
import '../models/order_model.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: orderController.orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return GestureDetector(
                onTap: () {
                  print('Order Details: ${order}');
                  orderController.currentOrder.value = order;
                  Get.to(() => OrderDetailPage());
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment, color: Color(0xFF39c5c8)),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${order.customerName} - ${order.orderCode}" ?? 'Undefined' ,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '\$${order.totalPrice?.toStringAsFixed(2)}${order.orderStatus != "DELIVERED" ? " - Pending" : ""}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF39c5c8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
