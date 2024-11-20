import 'package:flutter/material.dart';
import 'package:responsi/pages/restodata.dart';

class DetailPage extends StatelessWidget {
  final Restaurants restaurant;

  const DetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (restaurant.pictureId.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              restaurant.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              restaurant.city,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              restaurant.description,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify, // Mengatur teks menjadi justify
            ),
            const SizedBox(height: 10),
            Text(
              'Rating: ${restaurant.rating}',
              style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
