import 'package:restaurant_app/data/model/restaurant_element.dart';

class RestaurantsSearch {
  RestaurantsSearch({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<RestaurantElement> restaurants;

  factory RestaurantsSearch.fromJson(Map<String, dynamic> json) =>
      RestaurantsSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
