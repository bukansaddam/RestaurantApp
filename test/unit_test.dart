import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

void main() {
  test('Parsing JSON', () {
    var jsonString = {
      'id': '1',
      'name': 'Kafe Kita',
      'description': 'Tempat ngopi asik',
      'city': 'Kota Bandung',
      'rating': 4.2,
      'pictureId': '1',
    };

    var restaurant = Restaurant.fromJson(jsonString);

    expect(restaurant.id, '1');
    expect(restaurant.name, 'Kafe Kita');
    expect(restaurant.description, 'Tempat ngopi asik');
    expect(restaurant.city, 'Kota Bandung');
    expect(restaurant.rating, 4.2);
    expect(restaurant.pictureId, '1');
  });
}
