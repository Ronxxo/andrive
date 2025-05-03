// screens/predefined_trailers_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';
// ignore: unused_import
import 'package:share_plus/share_plus.dart';
import 'login_screen.dart';
import '../services/pdf_service.dart';

class PredefinedTrailersScreen extends StatelessWidget {
  final PdfService pdfService = PdfService();

  final List<Map<String, dynamic>> trailers = [
    {
      'name': 'Trailer de Exhibición',
      'description': '''
Medidas 160 de ancho x 2.00 de largo x 2.00 de altura
- Tubería 4*8 c-18
- Tubería 1 pulgada
- Tubería 3/4
- Tubería estructural
- Tubería 5*5 c-14
- Piso en fibra de madera 1.5mm
- Lámina galvanizada c-26 y c-28
- Sobre piso en tapete de alfanjor
- Mesas en acero inoxidable
- Vitrina frontal parte baja
- Vidrio para vitrina
- Pintura interior y exterior personalizada
- Techo en PVC
- Iluminación 110 y 12 voltios
- Brazos hidráulicos para ventanas
- 2 tomas corrientes
- 1 enganche 7/8
- 1 eje remanufacturado
- 2 llantas y rines remanufacturados
- 1 chapa de seguridad
- Caja para chapa
- Pasadores de seguridad
- Esquineros en lámina de alfanjor y galvanizada
''',
      'price': 6400000,
      'image': 'assets/images/trailer_1.jpg',
    },
    {
      'name': 'Trailer de Cocina',
      'description': '''
- Plancha de 60*40: \$370,000
- Freidora: \$220,000
- Vaporera: \$250,000
- Parrillas a carbón: \$475,000
- Parrilla de piedra volcánica: \$400,000
- Parrilla a gas: \$325,000
- Topping 1/9: \$30,000
- Topping 1/6: \$40,000
- Topping 1/3: \$50,000
- Lámina en alfajor de aluminio para piso: \$500,000
- Diseño, impresión e instalación: \$780,000
- Campana extractora de 1m x 40cm: \$1,400,000
- Plancha en acero inoxidable: \$525,000
- Cajones interiores: \$680,000
- Entrepaños en acero inoxidable: \$180,000 c/u
- Lavaplatos con cajón (sistema por gravedad): \$650,000
- Bodega para gas: \$350,000
''',
      'price': 8700000,
      'image': 'assets/images/trailer_2.jpg',
    },
    {
      'name': 'Trailer de Heladería',
      'description': '''
Medidas 170 de ancho x 2 de altura
- 2 mesas de trabajo en acero inoxidable
- Lavaplatos con sistema por gravedad
- Topping en acero inoxidable
- Cajón aéreo
- Espacio para refrigerador
- Iluminación
- 3 tomas corrientes
- Pintura interna y externa
- 2 ventanas laterales
- Puerta de ingreso
- Diseño, impresión e instalación gráfica
- Piso en tapete de alfanjor
''',
      'price': 7800000,
      'image': 'assets/images/trailer_3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trailers Predefinidos'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: trailers.length,
        itemBuilder: (context, index) {
          final trailer = trailers[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del trailer
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      trailer['image'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nombre del trailer
                  Text(
                    trailer['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Descripción del trailer
                  Text(trailer['description'], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  // Precio del trailer
                  Text(
                    'Precio: \$${trailer['price'].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Botón para Generar Cotización
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LoginScreen(
                                onLoginSuccess: (name, email) {
                                  _handleQuotation(
                                    context,
                                    trailer,
                                    name,
                                    email,
                                  );
                                },
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Generar Cotización',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Método para manejar la cotización
  void _handleQuotation(
    BuildContext context,
    Map<String, dynamic> trailer,
    String name,
    String email,
  ) async {
    try {
      // Generar el PDF usando tu servicio
      final File pdfFile = await pdfService.generateQuotation(
        name,
        email,
        trailer['description'],
        trailer['price'].toDouble(),
      );

      // Mostrar un snackbar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Cotización generada con éxito!')),
      );

      // Opcional: Compartir el PDF

      // Navegar de regreso
      Navigator.pop(context);
    } catch (e) {
      // Mostrar un snackbar de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar la cotización: $e')),
      );
    }
  }
}
