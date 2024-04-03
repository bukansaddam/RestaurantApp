import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/search_restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/card_restaurant.dart';

class SearchPage extends StatelessWidget {
  static const routeName = "/search_page";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SearchRestaurantProvider(apiService: ApiService()),
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Search Restaurant"),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, bottom: 16, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                      ),
                      onChanged: (value) {
                        Provider.of<SearchRestaurantProvider>(context,
                                listen: false)
                            .fetchAllRestaurant(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildRestaurantList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildRestaurantList() {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          if (state.result.restaurants.isEmpty) {
            return const Center(
              child: Material(
                child: Text("Restaurant Tidak Ditemukan"),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = state.result.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          }
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return const Center(
            child: Material(
              child: Text("Gagal memuat data"),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text("Restaurant Tidak Ditemukan"),
            ),
          );
        }
      },
    );
  }
}
