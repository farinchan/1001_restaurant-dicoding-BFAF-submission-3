import 'package:flutter/material.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_element.dart';
import 'package:restaurant_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantElement> _favorite = [];
  List<RestaurantElement> get favorite => _favorite;

  void _getFavorite() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      _favorite = await databaseHelper.getBookmarks();
      if (_favorite.length > 0) {
        _state = ResultState.HasData;
      } else {
        _state = ResultState.NoData;
        _message = 'Kamu Belum Menambahkan Restaurant ke Dalam Bookmark Kamu';
      }
      notifyListeners();
    } catch (e) {}
  }

  void addFavorite(RestaurantElement resto) async {
    try {
      await databaseHelper.insertBookmark(resto);
      _getFavorite();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final bookmarkedArticle = await databaseHelper.getBookmarkById(id);
    return bookmarkedArticle.isNotEmpty;
  }

  void removeBookmark(String id) async {
    try {
      await databaseHelper.removeBookmark(id);
      _getFavorite();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
