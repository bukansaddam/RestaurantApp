import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/detail_restaurant_provider.dart';

class DetailPage extends StatelessWidget {
  static const routeName = "/detail_page";

  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DetailRestaurantProvider(id, apiService: ApiService()),
        )
      ],
      child: Consumer2<DetailRestaurantProvider, DatabaseProvider>(
        builder: (context, detailState, databaseState, _) {
          if (detailState.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (detailState.state == ResultState.hasData) {
            var restaurant = detailState.result.detailRestaurant;
            return _buildDetail(context, restaurant, databaseState);
          } else if (detailState.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(detailState.message),
              ),
            );
          } else if (detailState.state == ResultState.error) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Material(
                  child: Text("Gagal memuat data"),
                ),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }

  Scaffold _buildDetail(BuildContext context, DetailRestaurant restaurant,
      DatabaseProvider databaseState) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Hero(
                      tag: restaurant.pictureId,
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: FutureBuilder(
                          future: databaseState.isBookmarked(restaurant.id),
                          builder: (context, snapshot) {
                            var isBookmarked = snapshot.data ?? false;
                            return IconButton(
                              onPressed: () {
                                if (isBookmarked) {
                                  databaseState.removeBookmark(restaurant.id);
                                } else {
                                  databaseState.addBookmark(
                                    Restaurant(
                                      id: restaurant.id,
                                      name: restaurant.name,
                                      description: restaurant.description,
                                      city: restaurant.city,
                                      rating: restaurant.rating,
                                      pictureId: restaurant.pictureId,
                                    ),
                                  );
                                }
                              },
                              icon: isBookmarked
                                  ? const Icon(
                                      Icons.bookmark,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.bookmark_border,
                                      color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(restaurant.rating.toString())
                        ],
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.grey,
                        size: 16,
                      ),
                      Text(
                        restaurant.city,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    restaurant.description,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Makanan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurant.menus.foods.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(restaurant.menus.foods[index].name),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Minuman",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurant.menus.drinks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(restaurant.menus.drinks[index].name),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
