import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../models/orderitem_model.dart';
import '../ultilities/Constant.dart';
import '../controllers/order_controller.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderController controller = Get.find(); // Tìm controller sử dụng GetX

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.currentOrder.value;
      if (order == null) {
        return const Center(child: CircularProgressIndicator());
      }

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
          iconTheme: const IconThemeData(color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchOrders();
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin tài xế giao hàng
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
                        child: order.orderStatus != 'PREPARING' || order.driverName == null
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              color: Color(0xFF39c5c8),
                              strokeWidth: 2.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              'Finding Driver...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                            : Row(
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

                      // const SizedBox(height: 8.0),

                      // Mã đơn hàng
                      Text(
                        order.orderCode ?? 'Unknown Order Code',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Chi tiết đơn hàng
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!.withOpacity(0.4),
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
                              'Ordered at: $formattedTime',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Order Items',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12.0),
                            ...items.map<Widget>((item) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(item!.foodName!, style: TextStyle(fontWeight: FontWeight.bold)),
                                trailing: Text("x${item?.quantity}"),
                              );
                            }).toList(),
                            const Divider(),
                            Text(
                              'Total: \$${order.totalPrice}',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Nút "Complete Order"
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Nút "Hủy đơn hàng"
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Màu đỏ cho nút hủy
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          // Gọi hàm hủy đơn hàng
                          controller.sendOrderStatusUpdate(order.id!, "RESTAURANT_DECLINE_ORDER");
                          controller.fetchOrders();
                          Get.back();
                        },
                        child: const Text(
                          'Cancel Order',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0), // Khoảng cách giữa hai nút

                    // Nút "Complete Order"
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39c5c8),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          // Gọi hàm hoàn thành đơn hàng
                          //controller.completeOrder(order.id!);
                          Get.snackbar("Complete Order", "Order Completed");
                        },
                        child: const Text(
                          'Complete Order',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
