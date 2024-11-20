import 'package:flutter/material.dart';
import 'package:responsi/pages/login_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(const RestoApp());
}

class RestoApp extends StatelessWidget {
  const RestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Apps',
      theme: ThemeData(
        fontFamily: 'QuicksandRegular',
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: RestoColors.primary,
        focusColor: RestoColors.primary,
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
