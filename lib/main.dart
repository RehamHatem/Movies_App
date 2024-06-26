import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/browse_tap/genre_data.dart';
import 'package:movies_app/screens/search_tap/searchResults.dart';



import 'firebase_options.dart';
import 'layouts/home_layouts/home.dart';
import 'layouts/home_layouts/movie_details.dart';
import 'layouts/splash.dart';
import 'screens/home_tap/popular_item.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName:(context) => SplashScreen(),
        HomeScreen.routeName:(context) => HomeScreen(),
        MovieDetails.routeName:(context) => MovieDetails(),
        GenreData.routeName:(context) => GenreData(),
      },
    );
  }
}
