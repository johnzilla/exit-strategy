import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home.dart';
import 'screens/setup.dart';
import 'services/subscription_service.dart';
import 'services/rescue_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(const ExitStrategyApp());
}

class ExitStrategyApp extends StatelessWidget {
  const ExitStrategyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
        ChangeNotifierProvider(create: (_) => SettingsService()),
        Provider(create: (_) => RescueService()),
      ],
      child: MaterialApp(
        title: 'Exit Strategy',
        theme: ThemeData(
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            secondary: Colors.amber,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/setup': (context) => const SetupScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}