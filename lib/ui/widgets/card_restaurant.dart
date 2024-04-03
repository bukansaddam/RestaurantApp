import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigation.intentWithData(
                        DetailPage.routeName, restaurant.id);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              tag: restaurant.pictureId,
                              child: Image.network(
                                "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            restaurant.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: isBookmarked
                                        ? IconButton(
                                            onPressed: () {
                                              provider.removeBookmark(
                                                  restaurant.id);
                                            },
                                            icon: const Icon(
                                              Icons.bookmark,
                                              color: Colors.red,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              provider.addBookmark(restaurant);
                                            },
                                            icon: const Icon(
                                              Icons.bookmark_border,
                                              color: Colors.red,
                                            ),
                                          ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  Text(
                                    restaurant.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
