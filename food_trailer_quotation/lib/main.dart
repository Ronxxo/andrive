import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; // Asegúrate de que esta línea esté correcta
import 'screens/predefined_trailers_screen.dart';
import 'screens/custom_trailer_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotizador de Trailers',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => HomeScreen(), // Pantalla inicial
        '/login': (context) => LoginScreen(), // Pantalla de login
        '/predefined':
            (context) =>
                PredefinedTrailersScreen(), // Pantalla de trailers predefinidos
        '/custom':
            (context) =>
                CustomTrailerScreen(), // Pantalla de trailers personalizados
      },
    );
  }
}
