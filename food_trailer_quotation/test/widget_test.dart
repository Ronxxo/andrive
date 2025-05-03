import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:food_trailer_quotation/screens/login_screen.dart';
import 'package:food_trailer_quotation/services/auth_service.dart';
import 'package:food_trailer_quotation/services/database_service.dart';
import 'package:food_trailer_quotation/services/pdf_service.dart';

void main() {
  setUpAll(() async {
    // Inicializa Firebase para las pruebas
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Carga inicial de la pantalla de inicio de sesión', (
    WidgetTester tester,
  ) async {
    // Construye la aplicación con los proveedores necesarios
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          Provider<DatabaseService>(create: (_) => DatabaseService()),
          Provider<PdfService>(create: (_) => PdfService()),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    // Verifica que la pantalla de inicio de sesión se cargue correctamente
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      find.text('Iniciar Sesión'),
      findsOneWidget,
    ); // Ajusta según el texto en tu LoginScreen
  });
}
