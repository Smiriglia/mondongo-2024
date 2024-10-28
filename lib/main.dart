
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );
  getIt.registerSingleton(AppRouter());
  getIt.registerSingleton(AuthService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = getIt.get<AppRouter>();

    return MaterialApp.router(
      title: 'Mondongo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
    );
  }
}
