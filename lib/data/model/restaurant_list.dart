import 'package:restaurant_app/data/model/restaurant_element.dart';

class Restaurant {
  Restaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<RestaurantElement> restaurants;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        error: json["error"] == null ? true : json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
