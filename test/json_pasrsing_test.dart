import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

import 'json_pasrsing_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Fetch restaurant api', () {
    final resto = {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        },
        {
          "id": "s1knt6za9kkfw1e867",
          "name": "Kafe Kita",
          "description":
              "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
          "pictureId": "25",
          "city": "Gorontalo",
          "rating": 4
        }
      ]
    };

    test('should contain list of restaurant when api success', () async {
      final api = ApiService();
      final client = MockClient();

      when(
        client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")),
      ).thenAnswer((_) async => http.Response(jsonEncode(resto), 200));

      expect(await api.listRestaurant(client), isA<Restaurant>());
    });
  });
}
