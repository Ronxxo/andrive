import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final bool showCurrency;
  final TextStyle? style;

  const PriceTag({required this.price, this.showCurrency = true, this.style});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CO',
      symbol: showCurrency ? '\$' : '',
      decimalDigits: 0,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFD4AF37).withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xFFD4AF37), width: 1),
      ),
      child: Text(
        currencyFormat.format(price),
        style:
            style ??
            TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
      ),
    );
  }
}
