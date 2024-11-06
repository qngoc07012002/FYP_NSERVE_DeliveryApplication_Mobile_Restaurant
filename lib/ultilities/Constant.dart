import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://nserve.ddns.net/nserve";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_URL = "$BACKEND_URL/auth/generateOTP";

  // ignore: constant_identifier_names
  static const VERIFY_OTP_URL = "$BACKEND_URL/auth/verifyOTP";

  // ignore: constant_identifier_names
  static const RESTAURANT_URL = "$BACKEND_URL/restaurants";

  // ignore: constant_identifier_names
  static const RESTAURANT_INFO_URL = "$RESTAURANT_URL/info";

  // ignore: constant_identifier_names
  static const FOOD_URL = "$BACKEND_URL/foods";

  // ignore: constant_identifier_names
  static const ORDER_RESTAURANT_URL = "$BACKEND_URL/orders/restaurant";

  // ignore: constant_identifier_names
  static const LOGOUT_URL = "$BACKEND_URL/auth/logout";

  // ignore: constant_identifier_names
  static const INTROSPECT_URL = "$BACKEND_URL/auth/introspect";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  // ignore: constant_identifier_names
  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjoxNzMwNzg4NzI1LCJpYXQiOjE3MzA3ODUxMjUsImp0aSI6IjZhYjFlNGMyLTdjY2EtNDRhYi05ZjBiLTBjNzAxYjE1Njg0MyIsInNjb3BlIjoiUk9MRV9DVVNUT01FUiBST0xFX0FETUlOIFJPTEVfUkVTVEFVUkFOVCBST0xFX0RSSVZFUiJ9.THQu77Y_HnbQHhlLC2Xx8liq5qCo36ri2udjoewUPIZy0kvu7yhjg7Z5oKsK7NX5sPH-8Q_bnsNlg4_XBTT1og";

  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}