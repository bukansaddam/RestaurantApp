import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailRestaurantProvider(String id,{required this.apiService}){
    _fetchDetailRestaurant(id);
  }

  late DetailRestaurantResult _detailRestaurantResult;
  late ResultState _state;
  String _message = "";

  String get message => _message;

  DetailRestaurantResult get result => _detailRestaurantResult;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final article = await apiService.detailRestaurant(id);
      if (article.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = article.message;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurantResult = article;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "Error --> $e";
    }
  }
}
