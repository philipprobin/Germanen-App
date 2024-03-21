import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/register/password_page.dart';
import 'package:germanenapp/utils/app_color.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'network/authentication_service.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor myColor = const MaterialColor(
    0xDA2A2A,
    <int, Color>{
      50: Color(0xFFDA2A2A),
      100: Color(0xFFDA2A2A),
      200: Color(0xFFDA2A2A),
      300: Color(0xFFDA2A2A),
      400: Color(0xFFDA2A2A),
      500: Color(0xFFDA2A2A),
      600: Color(0xFFDA2A2A),
      700: Color(0xFFDA2A2A),
      800: Color(0xFFDA2A2A),
      900: Color(0xFFDA2A2A),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService?>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Germanen-App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(AppColor.primary.value, <int, Color>{
            50: AppColor.primary,
            100: AppColor.primary,
            200: AppColor.primary,
            300: AppColor.primary,
            400: AppColor.primary,
            500: AppColor.primary,
            600: AppColor.primary,
            700: AppColor.primary,
            800: AppColor.primary,
            900: AppColor.primary,
          }),
          primaryColor: AppColor.primary
        ),
        home: AuthenticationWrapper(),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/homePage': (context) => HomePage(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      firebaseUser.reload();
      return HomePage();
    }
    debugPrint("main");
    return PasswordPage();
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}