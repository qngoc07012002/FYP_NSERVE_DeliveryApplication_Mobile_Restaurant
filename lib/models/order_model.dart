
import 'orderitem_model.dart';

class Order {
  String? id;
  String? orderCode;
  String? customerName;
  String? driverName;
  String? driverImgUrl;
  String? startLocation;
  String? endLocation;
  double? totalPrice;
  String? orderStatus;
  String? createAt;
  List<OrderItem>? orderItems;

  Order({
    this.id,
    this.orderCode,
    this.customerName,
    this.driverName,
    this.driverImgUrl,
    this.startLocation,
    this.endLocation,
    this.totalPrice,
    this.orderStatus,
    this.createAt,
    this.orderItems,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      orderCode: map['orderCode'],
      customerName: map['customerName'],
      driverName: map['driverName'],
      driverImgUrl: map['driverImgUrl'],
      startLocation: map['startLocation'],
      endLocation: map['endLocation'],
      totalPrice: map['totalPrice'],
      orderStatus: map['orderStatus'],
      createAt: map['createAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderCode': orderCode,
      'customerName': customerName,
      'driverName': driverName,
      'driverImgUrl': driverImgUrl,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'totalPrice': totalPrice,
      'orderStatus': orderStatus,
      'createAt': createAt,
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, orderCode: $orderCode, customerName: $customerName, driverName: $driverName, totalPrice: $totalPrice, orderStatus: $orderStatus, createAt: $createAt)';
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItemsJson = json['orderItems'] as List<dynamic>;
    List<OrderItem> orderItemsList = orderItemsJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();

    return Order(
      id: json['id'] ?? '',
      orderCode: json['orderCode'] ?? '',
      customerName: json['customerName'] ?? '',
      driverName: json['driverName'] ?? '',
      driverImgUrl: json['driverImgUrl'] ?? '',
      startLocation: json['startLocation'] ?? '',
      endLocation: json['endLocation'] ?? '',
      totalPrice: json['totalPrice'] ?? 0.0,
      orderStatus: json['orderStatus'] ?? '',
      createAt: json['createAt'] ?? '',
      orderItems: orderItemsList,
    );
  }
}

