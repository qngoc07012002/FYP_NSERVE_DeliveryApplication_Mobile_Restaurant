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
  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiMGU0OWQwNzctMGE0OC00Zjk1LTgzYWItNGQ5YWUxNTI3NDBlIiwiZXhwIjoxNzMwMTY2ODUxLCJpYXQiOjE3MzAxNjMyNTEsImp0aSI6ImEzMjZhMTk4LTA4ODctNGUxZi05OGEyLTJjNzcxY2E2YmQ1MiIsInNjb3BlIjoiUk9MRV9EUklWRVIgUk9MRV9DVVNUT01FUiBST0xFX1JFU1RBVVJBTlQgUk9MRV9BRE1JTiJ9.-PMDKYWZqbQFbGdJWutil1ra4xaf8AZdgISVl0aOXzh3-OKtfVqZy1tr4zQGHtYt3Hh5n6tyQtVgalj0R1GK0A";

  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}