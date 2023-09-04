import 'package:bv/services/statusAuth.dart';
import 'package:bv/themes/themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bv/pages/HomePage.dart';
import 'package:bv/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return ChangeNotifierProvider(
      create: (context) => BlocVerteTheme(),
      builder: (context, child){
        final provider = Provider.of<BlocVerteTheme>(context);
        return MaterialApp(
          title: 'Trano Maitso',
          theme: provider.theme,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
