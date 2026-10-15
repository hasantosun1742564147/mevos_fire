import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart' as xl;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hidrolik hesap tablosunun tek satırı (bir boru bölümü).
class SpReportRow {
  final String bolum; // 'dal' | 'tali' | 'ana'
  final String parca; // ör. "D1→D2"
  final double q; // bu noktadan eklenen debi (L/dk)
  final double qKum; // kümülatif debi (L/dk)
  final int dn;
  final double lDuz; // düz boru (m)
  final double lFit; // fitting eşdeğer boy (m)
  final double lToplam; // toplam eşdeğer boy (m)
  final double kayipBarM; // bar/m
  final double pt; // bölüm başı toplam basınç (bar)
  final double pe; // statik (yükseklik) basınç (bar)
  final double pf; // sürtünme kaybı (bar)
  final String? not;
  const SpReportRow({
    required this.bolum,
    required this.parca,
    required this.q,
    required this.qKum,
    required this.dn,
    required this.lDuz,
    required this.lFit,
    required this.lToplam,
    required this.kayipBarM,
    required this.pt,
    required this.pe,
    required this.pf,
    this.not,
  });
}

/// Rapor verisi — etiketler çağıran tarafından (yerelleştirilmiş) verilir.
class SpReportData {
  final String baslik;
  final List<(String, String)> ust; // başlık bilgileri (etiket, değer)
  final List<String> kolonlar; // 13 kolon başlığı (No … Not)
  final Map<String, String> bolumAdlari; // dal/tali/ana → yerel ad
  final List<SpReportRow> satirlar;
  final List<(String, String)> ozet; // alt toplamlar (etiket, değer)
  final String altNot;
  const SpReportData({
    required this.baslik,
    required this.ust,
    required this.kolonlar,
    required this.bolumAdlari,
    required this.satirlar,
    required this.ozet,
    required this.altNot,
  });
}

String _f(double v, [int d = 2]) => v.toStringAsFixed(d);

/// Noto Sans'ta bulunmayan karakterleri PDF için düz metne çevirir.
String _pdfSafe(String s) => s.replaceAll('√', 'sqrt').replaceAll('→', '-');

List<String> _satirHucreleri(int no, SpReportRow r) => [
  '$no',
  r.parca,
  _f(r.q, 1),
  _f(r.qKum, 1),
  'DN${r.dn}',
  _f(r.lDuz),
  _f(r.lFit),
  _f(r.lToplam),
  r.kayipBarM.toStringAsFixed(4),
  _f(r.pt, 3),
  _f(r.pe, 3),
  _f(r.pf, 3),
  _pdfSafe(r.not ?? ''),
];

Future<Uint8List> buildSpPdf(SpReportData d) async {
  final regular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
  );
  final bold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
  );
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: regular, bold: bold),
  );

  const headColor = PdfColor.fromInt(0xFFD9EDEA);
  const sectionColor = PdfColor.fromInt(0xFFF1F5F9);

  // Bölümlere göre gruplanmış veri satırları (sıra numarası kesintisiz)
  final bolumler = <String, List<List<String>>>{};
  int no = 0;
  for (final r in d.satirlar) {
    no++;
    bolumler.putIfAbsent(r.bolum, () => []).add(_satirHucreleri(no, r));
  }

  final colWidths = <int, pw.TableColumnWidth>{
    0: const pw.FixedColumnWidth(24),
    1: const pw.FixedColumnWidth(54),
    2: const pw.FixedColumnWidth(40),
    3: const pw.FixedColumnWidth(44),
    4: const pw.FixedColumnWidth(36),
    5: const pw.FixedColumnWidth(40),
    6: const pw.FixedColumnWidth(42),
    7: const pw.FixedColumnWidth(42),
    8: const pw.FixedColumnWidth(48),
    9: const pw.FixedColumnWidth(42),
    10: const pw.FixedColumnWidth(38),
    11: const pw.FixedColumnWidth(42),
    12: const pw.FlexColumnWidth(),
  };

  const cellStyle = pw.TextStyle(fontSize: 7.5);
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(24),
      header: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _pdfSafe(d.baslik),
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Wrap(
            spacing: 18,
            runSpacing: 2,
            children: [
              for (final (k, v) in d.ust)
                pw.Text(_pdfSafe('$k: $v'), style: const pw.TextStyle(fontSize: 8.5)),
            ],
          ),
          pw.SizedBox(height: 6),
        ],
      ),
      footer: (c) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          '${c.pageNumber} / ${c.pagesCount}',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
      build: (_) => [
        for (final (idx, e) in bolumler.entries.indexed) ...[
          pw.Container(
            width: double.infinity,
            color: sectionColor,
            padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: pw.Text(
              d.bolumAdlari[e.key] ?? e.key,
              style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.TableHelper.fromTextArray(
            headers: idx == 0 ? d.kolonlar : null,
            data: e.value,
            columnWidths: colWidths,
            headerStyle: pw.TextStyle(
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: headColor),
            cellStyle: cellStyle,
            cellAlignments: {
              for (var i = 0; i < 13; i++)
                i: i == 12 ? pw.Alignment.centerLeft : pw.Alignment.center,
            },
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 2.5,
            ),
            border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.4),
          ),
        ],
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey600, width: 0.6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final (k, v) in d.ozet)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 1),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 260,
                        child: pw.Text(
                          _pdfSafe(k),
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                      pw.Text(
                        _pdfSafe(v),
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          _pdfSafe(d.altNot),
          style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
        ),
      ],
    ),
  );
  return doc.save();
}

Uint8List buildSpXlsx(SpReportData d) {
  final book = xl.Excel.createExcel();
  const sheetName = 'Hidrolik';
  book.rename(book.getDefaultSheet()!, sheetName);
  final sh = book[sheetName];

  final bold = xl.CellStyle(bold: true);
  final head = xl.CellStyle(
    bold: true,
    backgroundColorHex: xl.ExcelColor.fromHexString('#D9EDEA'),
    horizontalAlign: xl.HorizontalAlign.Center,
  );
  final section = xl.CellStyle(
    bold: true,
    backgroundColorHex: xl.ExcelColor.fromHexString('#F1F5F9'),
  );

  void put(int col, int row, xl.CellValue v, [xl.CellStyle? st]) {
    final c = sh.cell(
      xl.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
    );
    c.value = v;
    if (st != null) c.cellStyle = st;
  }

  int row = 0;
  put(0, row++, xl.TextCellValue(d.baslik), bold);
  for (final (k, v) in d.ust) {
    put(0, row, xl.TextCellValue(k), bold);
    put(2, row++, xl.TextCellValue(v));
  }
  row++;
  for (var i = 0; i < d.kolonlar.length; i++) {
    put(i, row, xl.TextCellValue(d.kolonlar[i]), head);
  }
  row++;

  String? last;
  int no = 0;
  for (final r in d.satirlar) {
    if (r.bolum != last) {
      last = r.bolum;
      put(0, row++, xl.TextCellValue(d.bolumAdlari[r.bolum] ?? r.bolum), section);
    }
    no++;
    put(0, row, xl.IntCellValue(no));
    put(1, row, xl.TextCellValue(r.parca));
    put(2, row, xl.DoubleCellValue(double.parse(_f(r.q, 1))));
    put(3, row, xl.DoubleCellValue(double.parse(_f(r.qKum, 1))));
    put(4, row, xl.IntCellValue(r.dn));
    put(5, row, xl.DoubleCellValue(double.parse(_f(r.lDuz))));
    put(6, row, xl.DoubleCellValue(double.parse(_f(r.lFit))));
    put(7, row, xl.DoubleCellValue(double.parse(_f(r.lToplam))));
    put(8, row, xl.DoubleCellValue(double.parse(r.kayipBarM.toStringAsFixed(4))));
    put(9, row, xl.DoubleCellValue(double.parse(_f(r.pt, 3))));
    put(10, row, xl.DoubleCellValue(double.parse(_f(r.pe, 3))));
    put(11, row, xl.DoubleCellValue(double.parse(_f(r.pf, 3))));
    if (r.not != null) put(12, row, xl.TextCellValue(r.not!));
    row++;
  }

  row++;
  for (final (k, v) in d.ozet) {
    put(0, row, xl.TextCellValue(k), bold);
    put(7, row++, xl.TextCellValue(v), bold);
  }
  row++;
  put(0, row, xl.TextCellValue(d.altNot));

  sh.setColumnWidth(0, 6);
  sh.setColumnWidth(1, 14);
  for (var i = 2; i <= 11; i++) {
    sh.setColumnWidth(i, 12);
  }
  sh.setColumnWidth(12, 48);

  return Uint8List.fromList(book.encode()!);
}

/// Mobilde paylaşım menüsünü açar. Masaüstünde (paylaşım penceresi bellekteki
/// dosyayı desteklemediği için) İndirilenler klasörüne kaydedip varsayılan
/// programla açar ve kaydedilen yolu döndürür.
Future<String?> shareSpReport(
  Uint8List bytes, {
  required String fileName,
  required String mimeType,
}) async {
  final masaustu =
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  if (!masaustu) {
    await Share.shareXFiles([
      XFile.fromData(bytes, mimeType: mimeType, name: fileName),
    ], fileNameOverrides: [fileName]);
    return null;
  }
  final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
  var dir = home == null ? Directory.systemTemp : Directory('$home${Platform.pathSeparator}Downloads');
  if (!dir.existsSync()) dir = Directory.systemTemp;
  final file = File('${dir.path}${Platform.pathSeparator}$fileName');
  await file.writeAsBytes(bytes, flush: true);
  await launchUrl(Uri.file(file.path));
  return file.path;
}
