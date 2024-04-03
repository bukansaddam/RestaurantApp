import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/bookmark_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/ui/setting_page.dart';
import 'package:restaurant_app/ui/widgets/card_restaurant.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, BookmarkPage.routeName);
        },
        child: const Icon(
          Icons.bookmark,
          color: Colors.red,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Restaurant",
                    style: TextStyle(fontSize: 32),
                  ),
                  Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SearchPage.routeName);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SettingPage.routeName);
                          },
                          icon: const Icon(Icons.settings))
                    ],
                  )
                ],
              ),
              const Text(
                "Recommendation restaurant for you!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ChangeNotifierProvider(
                  create: (_) => RestaurantProvider(apiService: ApiService()),
                  child: _buildRestaurantList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
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
              child: Text(""),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
