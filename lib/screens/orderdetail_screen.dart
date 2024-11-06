import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';
import '../models/orderitem_model.dart';
import '../ultilities/Constant.dart'; // Để định dạng thời gian

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final deliveryPerson = {
      'name': order.driverName ?? 'Unknown Driver',
      'avatarUrl': Constant.BACKEND_URL + order.driverImgUrl!
    };

    final List<OrderItem> items = order.orderItems ?? [];

    final createTime = DateTime.parse(order.createAt!);
    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(createTime);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Person Info
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.blueGrey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF39c5c8).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(deliveryPerson['avatarUrl']!),
                    radius: 30.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      deliveryPerson['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Order Code
            Text(
              order.orderCode ?? 'Unknown Order Code',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),

            // Order Details (formatted as a receipt)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  for (var item in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.foodName ?? 'Unknown Item',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'x${item.quantity ?? 0}',
                            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 24.0, thickness: 1.0),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Total: \$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Complete Order button (only if order status is PENDING)
            if (order.orderStatus == 'PENDING')
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Define the action for completing the order here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39c5c8),
                    padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Complete Order',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
