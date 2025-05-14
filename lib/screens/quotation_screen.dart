import 'package:flutter/material.dart';

class QuotationScreen extends StatelessWidget {
  final String name;
  final String email;
  final dynamic quotation; // Cambia el tipo según tu modelo de datos

  QuotationScreen({
    required this.name,
    required this.email,
    this.quotation,
    required String phone, // Agregar este parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotización'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Correo: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            if (quotation != null) ...[
              Text('Cotización: $quotation', style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
