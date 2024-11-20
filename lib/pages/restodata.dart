class Restaurant {
  final bool error;
  final String message;
  final int count;
  final List<Restaurants> restaurants;

  Restaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var list = json['restaurants'] as List;
    List<Restaurants> restaurantList =
        list.map((i) => Restaurants.fromJson(i)).toList();

    return Restaurant(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: restaurantList,
    );
  }
}

class Restaurants {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) {
    return Restaurants(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num).toDouble(), // Pastikan ini double
    );
  }
}
