import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";
  static const String _list = "list";
  static const String _detail = "detail/";
  static const String _search = "search?q=";

  Future<RestaurantResult> listRestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl + _list));
    if(response.statusCode == 200){
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  Future<DetailRestaurantResult> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detail + id));
    if(response.statusCode == 200){
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load detail restaurant");
    }
  }

  Future<SearchRestaurantResult> searchRestaurant(String name) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + name));
    if(response.statusCode == 200){
      return SearchRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurant");
    }
  }
}