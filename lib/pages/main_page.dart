import 'package:flutter/material.dart';
import 'package:responsi/components/loading.dart';
import 'package:responsi/components/my_appbar.dart';
import 'package:responsi/db/shared_preferences.dart';
import 'package:responsi/pages/home_page.dart';
import 'package:responsi/pages/login_page.dart';
import 'package:responsi/utils/theme.dart';

class MainPage extends StatefulWidget {
  final String username; // Menyimpan username yang diterima

  const MainPage({super.key, required this.username}); // Mengambil username dari constructor

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // New
  late bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    DBHelper().setPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body() {
      switch (_currentIndex) {
        case 0:
          return const HomePage();

        default:
          return const HomePage();
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: myAppBar(
            context,
            title: 'Resto Apps',
            automaticImplyLeading: false,
            action: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: RestoColors.red,
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed((const Duration(seconds: 2)), () {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, ${widget.username}!', // Menampilkan pesan sambutan
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: body()), // Membuat body dari halaman
            ],
          ),
        ),
        LoadingScreen(loading: _isLoading),
      ],
    );
  }
}
