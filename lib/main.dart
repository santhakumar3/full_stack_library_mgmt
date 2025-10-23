import 'package:flutter/material.dart';
import 'package:library_mgmt_flutter_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/book_provider.dart';
import 'providers/user_provider.dart';
import 'providers/issued_book_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => IssuedBookProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Library App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
