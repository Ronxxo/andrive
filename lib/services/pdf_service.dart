import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfService {
  Future<void> generateQuotation(
    String name,
    String email,
    String phone,
    String details,
    double price, {
    String? imagePath,
    Function(File)? onFile, // Callback para móvil/desktop
  }) async {
    final pdf = pw.Document();

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: const PdfColor.fromInt(0xFFD4AF37),
    );

    final titleStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );

    const normalStyle = pw.TextStyle(fontSize: 14);

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(child: pw.Text('COTIZACIÓN', style: headerStyle)),
                pw.SizedBox(height: 20),
                pw.Text('Información del Cliente:', style: titleStyle),
                pw.SizedBox(height: 8),
                pw.Text('Nombre: $name', style: normalStyle),
                pw.Text('Correo: $email', style: normalStyle),
                pw.Text('Teléfono: $phone', style: normalStyle),
                pw.Divider(),
                pw.Text('Detalles del Trailer:', style: titleStyle),
                pw.SizedBox(height: 8),
                pw.Text(details, style: normalStyle),
                pw.SizedBox(height: 20),
                if (imagePath != null &&
                    !kIsWeb &&
                    File(imagePath).existsSync())
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(File(imagePath).readAsBytesSync()),
                      height: 180,
                      width: 300,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      'TOTAL: \$${price.toStringAsFixed(0)}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Divider(),
                pw.Text(
                  'Gracias por su preferencia. Esta cotización es válida por 15 días.',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
      ),
    );

    final pdfBytes = await pdf.save();

    if (kIsWeb) {
      // En web, muestra el diálogo de impresión/descarga
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } else {
      // En móvil/escritorio, guarda el archivo y llama al callback si existe
      final output = await getTemporaryDirectory();
      final file = File(
        '${output.path}/cotizacion_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(pdfBytes);
      if (onFile != null) onFile(file);
    }
  }
}
