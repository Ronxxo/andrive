import 'package:flutter/material.dart';
import 'package:food_trailer_quotation/screens/predefined_trailers_screen.dart';
import 'package:food_trailer_quotation/screens/custom_trailer_screen.dart';
import 'package:food_trailer_quotation/screens/login_screen.dart';
import 'package:food_trailer_quotation/screens/catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizador de Trailers'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo y eslogan
                  Column(
                    children: [
                      const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Color(0xFFD4AF37), // Dorado
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'TRAILERS Y REMOLQUES P&J',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37), // Dorado
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Movilizando tu negocio, exhibiendo tu potencial.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Botones de acción
                  _buildMenuButton(
                    context,
                    'Ver Trailers Predefinidos',
                    Icons.list_alt,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PredefinedTrailersScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Crear Trailer Personalizado',
                    Icons.build,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomTrailerScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Ver Catálogo Completo',
                    Icons.menu_book,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CatalogScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Acceso Clientes',
                    Icons.login,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37), // Dorado
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[800]!, width: 1),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
