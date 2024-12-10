import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://10.0.2.2:8080/nserve";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_URL = "$BACKEND_URL/auth/generateOTP";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_RESTAURANT_URL = "$BACKEND_URL/auth/restaurant/generateOTP";

  // ignore: constant_identifier_names
  static const VERIFY_OTP_URL = "$BACKEND_URL/auth/verifyOTP";

  // ignore: constant_identifier_names
  static const REGISTER_RESTAURANT_URL = "$BACKEND_URL/users/registerRestaurant";

  // ignore: constant_identifier_names
  static const RESTAURANT_URL = "$BACKEND_URL/restaurants";

  // ignore: constant_identifier_names
  static const RESTAURANT_INFO_URL = "$RESTAURANT_URL/info";

  // ignore: constant_identifier_names
  static const FOOD_URL = "$BACKEND_URL/foods";

  // ignore: constant_identifier_names
  static const ORDER_URL = "$BACKEND_URL/orders";

  // ignore: constant_identifier_names
  static const ORDER_RESTAURANT_URL = "$BACKEND_URL/orders/restaurant";

  // ignore: constant_identifier_names
  static const LOGOUT_URL = "$BACKEND_URL/auth/logout";

  // ignore: constant_identifier_names
  static const INTROSPECT_URL = "$BACKEND_URL/auth/introspect";

  // ignore: constant_identifier_names
  static const UPDATE_RESTAURANT_URL = "$BACKEND_URL/users/updateRestaurant";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  // ignore: constant_identifier_names
  static const WEBSOCKET_URL = "$BACKEND_URL/ws";

  // ignore: constant_identifier_names
  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjoxNzQxODU4MjI2LCJpYXQiOjE3MzM4NTgyMjYsImp0aSI6IjI0MWRhMjkwLTZmNGItNGRiMC04MjYyLTYxYWYzZDZiMTBiMCIsInNjb3BlIjoiIn0.12sKJ9QYa-BhG5mXNimIgTrhHrO4zRcrF7UJD2VsSPg05L0gdDrsvWS12VSCqdGD6Tnr9ZU4P9zbXnzYFwqC2A";

  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}