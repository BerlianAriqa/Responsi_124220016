import 'package:flutter/material.dart';
import 'package:responsi/components/touchable_opacity.dart';
import 'package:responsi/utils/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar Content.
  final List<Map<String, dynamic>> contents = [
    
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: contents
              .map(
                (data) => TouchableOpacity(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => data['link']));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: RestoColors.shadow.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          data['icon'],
                          size: 32,
                          color: data['color'],
                        ),
                        const SizedBox(height: 10),
                        Text(data['name'], style: RestoFonts(context).boldQuicksand(size: 16)),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
