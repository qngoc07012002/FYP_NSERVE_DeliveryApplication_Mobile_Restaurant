import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://10.0.2.2:8080/nserve";

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
  static const ORDER_URL = "$BACKEND_URL/orders";

  // ignore: constant_identifier_names
  static const ORDER_RESTAURANT_URL = "$BACKEND_URL/orders/restaurant";

  // ignore: constant_identifier_names
  static const LOGOUT_URL = "$BACKEND_URL/auth/logout";

  // ignore: constant_identifier_names
  static const INTROSPECT_URL = "$BACKEND_URL/auth/introspect";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  // ignore: constant_identifier_names
  static const WEBSOCKET_URL = "$BACKEND_URL/ws";

  // ignore: constant_identifier_names
  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjozNjE3MzM1MTQyMzksImlhdCI6MTczMzUxNDIzOSwianRpIjoiNjY1MjMwMTEtMzE4ZS00ZTUwLWI3NzktMWE1ZGRhMzkyYmU1Iiwic2NvcGUiOiJST0xFX0FETUlOIFJPTEVfUkVTVEFVUkFOVCBST0xFX0NVU1RPTUVSIFJPTEVfRFJJVkVSIn0.fyad8YgYSOMfiqFW7cdfIvjQGt2xuYyB45oM6PK-ze2HXMh_KrWFtjmJ26atRJsgyjuebTcGWJsBWosi-XMfQg";

  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}