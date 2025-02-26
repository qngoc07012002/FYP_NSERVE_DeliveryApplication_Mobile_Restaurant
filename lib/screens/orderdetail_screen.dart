import 'package:deliveryapplication_mobile_restaurant/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../models/orderitem_model.dart';
import '../ultilities/Constant.dart';
import '../controllers/order_controller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.currentOrder.value;
      if (controller.currentOrder.value == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        print("ORDER STATUS: ${controller.currentOrder.value?.orderStatus}");
        print("DRIVER NAME: ${controller.currentOrder.value?.driverName}");
        print("DRIVER IMGURL: ${controller.currentOrder.value?.driverImgUrl}");
      }

      // if (controller.currentOrder.value!.orderStatus! == "CANCELED"){
      //   Get.dialog(
      //       Dialog(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(15.0),
      //         ),
      //         child: Container(
      //           padding: const EdgeInsets.all(16.0),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.circular(15.0),
      //           ),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text(
      //                 "Notification",
      //                 style: TextStyle(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               const SizedBox(height: 16.0),
      //
      //               Text(
      //                 "No Driver Found.",
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   color: Colors.grey[700],
      //                 ),
      //               ),
      //               const SizedBox(height: 24.0),
      //
      //               ElevatedButton(
      //                 onPressed: () {
      //                   controller.fetchOrders();
      //                   Get.back();
      //                   Get.offAll(RestaurantDashboardPage());
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: const Color(0xFF39c5c8), // Màu nút
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                   ),
      //                   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      //                 ),
      //                 child: Text(
      //                   "OK",
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ));
      // }

      final List<OrderItem> items = controller.currentOrder.value?.orderItems ?? [];
      final createTime = DateTime.parse(order!.createAt!).toLocal();
      final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(createTime);

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF39c5c8),
          title: const Text(
            'Invoice',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          toolbarHeight: 80.0,
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
                        child: controller.currentOrder.value?.orderStatus == 'FINDING_DRIVER' || controller.currentOrder.value?.orderStatus == 'PENDING' || order.driverName == null
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
                              backgroundImage: NetworkImage(Constant.IMG_URL + controller.currentOrder.value!.driverImgUrl!),
                              radius: 30.0,
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                controller.currentOrder.value!.driverName ?? 'Unknown',
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
                              'Order Code: ${order.orderCode}' ,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
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
                            const Divider(),
                            Text(
                              'Ordered at: $formattedTime',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // "Cancel Order"
              if (controller.currentOrder.value?.orderStatus != "DELIVERED" && controller.currentOrder.value?.orderStatus != "CANCELED")
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
                          onPressed: () async {
                            // Gọi hàm hủy đơn hàng
                            controller.sendOrderStatusUpdate(order.id!, "RESTAURANT_DECLINE_ORDER");
                            controller.currentOrder.value?.orderStatus = "CANCELED";
                            await controller.fetchOrders();
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
                      if (controller.currentOrder.value?.orderStatus == "PREPARING")
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
                            controller.sendOrderStatusUpdate(order.id!, "RESTAURANT_PREPARED_ORDER");
                            controller.currentOrder.value?.orderStatus = "DELIVERED";
                            Get.snackbar("Complete Order", "Order Completed");
                            setState(() {

                            });
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
