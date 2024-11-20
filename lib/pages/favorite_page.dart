import 'package:flutter/material.dart';
import 'package:responsi/utils/theme.dart';
import 'package:responsi/pages/restodata.dart'; // Ensure you import your Restaurant model

class FavoritePage extends StatelessWidget {
  final List<Restaurants> favoriteRestaurants;
  final Function(Restaurants) onRemoveFavorite; // Callback for removing a favorite

  const FavoritePage({
    super.key,
    required this.favoriteRestaurants,
    required this.onRemoveFavorite, // Add the callback parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns desired
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: favoriteRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = favoriteRestaurants[index];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  // Handle tapping on the restaurant card
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(restaurant.name, style: RestoFonts(context).boldQuicksand(size: 16)),
                          IconButton(
                            onPressed: () {
                              onRemoveFavorite(restaurant); // Call the callback to remove the favorite
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
