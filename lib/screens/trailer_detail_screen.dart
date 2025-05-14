import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trailer_model.dart';
import '../models/component_model.dart';
import '../models/quotation_model.dart';
import '../services/auth_service.dart';
import 'quotation_screen.dart';
import 'package:intl/intl.dart';

class TrailerDetailScreen extends StatefulWidget {
  final TrailerModel trailer;
  final bool isCustomizable;
  final List<Component>? selectedComponents;

  TrailerDetailScreen({
    required this.trailer,
    required this.isCustomizable,
    this.selectedComponents,
  });

  @override
  _TrailerDetailScreenState createState() => _TrailerDetailScreenState();
}

class _TrailerDetailScreenState extends State<TrailerDetailScreen> {
  final currencyFormat = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  double _totalPrice = 0;
  bool _isGeneratingQuotation = false;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    double componentsTotal = 0;
    if (widget.selectedComponents != null) {
      componentsTotal = widget.selectedComponents!.fold(
        0.0,
        (sum, component) => sum + component.price,
      );
    }

    setState(() {
      _totalPrice = widget.trailer.price + componentsTotal;
    });
  }

  void _generateQuotation() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe iniciar sesión para generar una cotización'),
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingQuotation = true;
    });

    try {
      final quotation = Quotation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        userName: user.name,
        userEmail: user.email,
        predefinedTrailer: widget.trailer,
        trailerBase:
            null, // Si es un trailer predefinido, no hay base personalizada
        components: widget.selectedComponents ?? [],
        totalPrice: _totalPrice,
        date: DateTime.now(),
        userPhone: '',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => QuotationScreen(
                quotation: quotation,
                name: '',
                email: '',
                phone: '',
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar cotización: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingQuotation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Trailer')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del trailer
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    widget.trailer.imageUrl.isEmpty
                        ? Icon(
                          Icons.directions_car,
                          size: 80,
                          color: Colors.grey[600],
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.trailer.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.error,
                                size: 80,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
              ),
              SizedBox(height: 24),

              // Nombre y precio
              Text(
                widget.trailer.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Precio base: ${currencyFormat.format(widget.trailer.price)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Descripción
              if (widget.trailer.description.isNotEmpty) ...[
                Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  widget.trailer.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],

              // Características
              Text(
                'Características:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...widget.trailer.features
                  .map(
                    (feature) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              SizedBox(height: 24),

              // Componentes seleccionados (si hay)
              if (widget.selectedComponents != null &&
                  widget.selectedComponents!.isNotEmpty) ...[
                Text(
                  'Componentes adicionales:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...widget.selectedComponents!
                    .map(
                      (component) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              component.name,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              currencyFormat.format(component.price),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                SizedBox(height: 16),
                Divider(),
              ],

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(_totalPrice),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Botón de cotización
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isGeneratingQuotation ? null : _generateQuotation,
                  child:
                      _isGeneratingQuotation
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : Text(
                            'GENERAR COTIZACIÓN',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
