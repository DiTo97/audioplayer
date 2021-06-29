import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Custom imports
import 'package:companion/viewmodels/view_model_media.dart';
import 'package:companion/views/screens/screen_home.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown]).then((_) {
    runApp(Companion());
  });
}


class Companion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MediaViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen()
        },
        title: 'Companion',
        theme: ThemeData(
            appBarTheme: AppBarTheme(),
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange
        ),
      ),
    );
  }
}
