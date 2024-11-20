import 'package:flutter/material.dart';
import 'package:responsi/components/loading.dart';
import 'package:responsi/components/my_appbar.dart';
import 'package:responsi/db/shared_preferences.dart';
import 'package:responsi/pages/home_page.dart';
import 'package:responsi/pages/login_page.dart';
import 'package:responsi/utils/theme.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; //New
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
          appBar: myAppBar(context, title: 'Resto Apps', automaticImplyLeading: false, action: [
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
          ]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex, //New
            type: BottomNavigationBarType.fixed,
            selectedItemColor: RestoColors.primary,
            backgroundColor: Colors.white,
            elevation: 20,
            iconSize: 32,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: RestoColors.grey,
            showSelectedLabels: true,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help),
                label: 'Bantuan',
              ),
            ],
          ),
          body: body(),
        ),
        LoadingScreen(loading: _isLoading)
      ],
    );
  }
}
