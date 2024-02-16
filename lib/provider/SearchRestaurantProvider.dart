import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum ResultSearchState { loading, noData, hasData, error }

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService});

  late SearchRestaurantResult _restaurantResult;
  ResultSearchState? _state;
  String _message = "";

  String get message => _message;
  SearchRestaurantResult get result => _restaurantResult;
  ResultSearchState? get state => _state;

  Future<dynamic> fetchAllRestaurant(String name) async {
    try {
      _state = ResultSearchState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(name);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultSearchState.noData;
        notifyListeners();
      } else {
        _state = ResultSearchState.hasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch(e) {
      _state = ResultSearchState.error;
      notifyListeners();
      return _message = "Error --> $e";
    }
  }
}