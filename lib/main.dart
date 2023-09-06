import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/pages/index_city.dart';
import 'package:conferences_mobile/pages/authentification/login.dart';
import 'package:conferences_mobile/pages/authentification/logout.dart';
import 'package:conferences_mobile/pages/authentification/register.dart';
import 'package:conferences_mobile/pages/conferences/conferences_all.dart';
import 'package:conferences_mobile/pages/organizations/organizations_create.dart';
import 'package:conferences_mobile/pages/organizations/organizations_offers_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/homepage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthModel(),
    child: const MyWidget(),
  ));
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proba',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/conferences': (context) => const ConferencesAllScreen(),
        '/indexCity': (context) => const IndexCity(),
        '/register': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/logout': (context) => const LogoutScreen(),
        '/organizationsCreate': (context) => const OrganizationCreateScreen(),
        '/organizationsOffers': (context) => const OrganizationsOfferScreen(),
      },
    );
  }
}
