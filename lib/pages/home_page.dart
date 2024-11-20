import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:responsi/components/touchable_opacity.dart';
import 'package:responsi/pages/favorite_page.dart';
import 'package:responsi/pages/detail_page.dart';
import 'package:responsi/pages/restodata.dart';
import 'package:responsi/utils/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Restaurants> restaurants = [];
  List<Restaurants> favoriteRestaurants = [];
  bool isLoading = true;
  final Dio _dio = Dio();
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final response = await _dio.get('https://restaurant-api.dicoding.dev/list');

      if (response.statusCode == 200) {
        final restaurantData = Restaurant.fromJson(response.data);
        setState(() {
          restaurants = restaurantData.restaurants;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching restaurants: $e');
    }
  }

  void toggleFavorite(Restaurants restaurant) {
    setState(() {
      if (favoriteRestaurants.contains(restaurant)) {
        favoriteRestaurants.remove(restaurant);
      } else {
        favoriteRestaurants.add(restaurant);
      }
    });
  }

  void removeFavorite(Restaurants restaurant) {
    setState(() {
      favoriteRestaurants.remove(restaurant);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GridView.builder(
              controller: _scrollController, // Menghubungkan ScrollController
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                Color cardColor = Colors.grey[300]!;

                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      cardColor = Colors.grey[400]!;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      cardColor = Colors.grey[300]!;
                    });
                  },
                  child: TouchableOpacity(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(restaurant: restaurant),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: cardColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (restaurant.pictureId.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                                height: 100,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            restaurant.name,
                            style: RestoFonts(context).boldQuicksand(size: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            restaurant.city,
                            style: TextStyle(color: RestoColors.grey),
                          ),
                          Text(
                            restaurant.rating.toString(),
                            style: TextStyle(color: RestoColors.primary),
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteRestaurants.contains(restaurant)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteRestaurants.contains(restaurant)
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () => toggleFavorite(restaurant),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );

    if (_currentIndex == 1) {
      currentPage = FavoritePage(
        favoriteRestaurants: favoriteRestaurants,
        onRemoveFavorite: removeFavorite,
      );
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scroll ke atas
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
