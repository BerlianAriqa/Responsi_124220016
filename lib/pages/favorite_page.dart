import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:responsi/db/local.dart';
import 'package:responsi/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_appbar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> data = [];

  Future<void> _loadItems() async {
    final source = SaveToLocalDb.getString('favorite');
    List<dynamic> items = source == null ? [] : jsonDecode(source);
    if (items.isNotEmpty) {
      setState(() {
        data = items;
      });
    }
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  _launchURL(dynamic url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(context, title: 'Favorite', leading: true),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Jumlah kolom yang diinginkan
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    _launchURL(Uri.parse(data[index]['link']));
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
                            data[index]['image'],
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
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
                            Text(data[index]['name'], style: RestoFonts(context).boldQuicksand(size: 16)),
                            IconButton(
                              onPressed: () {
                                data.remove(data[index]);

                                SaveToLocalDb.setString('favorite', jsonEncode(data));

                                setState(() {
                                  _loadItems();
                                });
                               // alert(context, icon: Icons.delete, color: Colors.red, text: 'Data ${data[index]['name']} berhasil di hapus');
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
