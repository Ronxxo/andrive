import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfService {
  Future<File> generateQuotation(
    String name,
    String email,
    String phone,
    String details,
    double price,
    dynamic GoogleFonts, {
    String? imagePath,
  }) async {
    final pdf = pw.Document();

    // Cargar fuentes
    final openSansRegular = await GoogleFonts.getFont('Open Sans');
    final openSansBold = await GoogleFonts.getFont(
      'Open Sans',
      fontWeight: pw.FontWeight.bold,
    );

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(0xFFD4AF37),
    );

    final titleStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );

    final normalStyle = pw.TextStyle(fontSize: 14);

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(openSansRegular),
          bold: pw.Font.ttf(openSansBold),
        ),
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

                if (imagePath != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(File(imagePath).readAsBytesSync()),
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
                        color: PdfColor.fromInt(0xFFD4AF37),
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

    final output = await getTemporaryDirectory();
    final file = File(
      '${output.path}/cotizacion_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
