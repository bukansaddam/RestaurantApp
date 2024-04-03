import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/widgets/card_restaurant.dart';

class BookmarkPage extends StatelessWidget {
  static const String routeName = "/bookmark_page";

  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.bookmarks[index]);
            },
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }
}
