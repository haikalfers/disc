import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
    ),
    home: const WelcomeScreen(),
  ));
}

class HitungDiskonApp extends StatefulWidget {
  const HitungDiskonApp({super.key});

  @override
  _HitungDiskonAppState createState() => _HitungDiskonAppState();
}

class _HitungDiskonAppState extends State<HitungDiskonApp> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController diskonController = TextEditingController();
  final TextEditingController diskonKeduaController = TextEditingController();

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  void hitungDiskon() {
    String nama = namaController.text;
    double? harga = double.tryParse(hargaController.text);
    double? diskon1 = double.tryParse(diskonController.text);
    double? diskon2 = double.tryParse(diskonKeduaController.text);

    if (nama.isEmpty || harga == null || diskon1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("⚠️ Mohon isi semua field dengan benar."),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    double potongan1 = (diskon1 / 100) * harga;
    double hargaSetelahDiskon1 = harga - potongan1;

    double potongan2 = 0;
    if (diskon2 != null && diskon2 > 0) {
      potongan2 = (diskon2 / 100) * hargaSetelahDiskon1;
    }

    double hargaAkhir = hargaSetelahDiskon1 - potongan2;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HasilPage(
          namaBarang: nama,
          harga: harga,
          diskon: diskon1,
          potongan: potongan1,
          diskonKedua: diskon2,
          potonganKedua: potongan2,
          hargaAkhir: hargaAkhir,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void reset() {
    namaController.clear();
    hargaController.clear();
    diskonController.clear();
    diskonKeduaController.clear();
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = true}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: TextStyle(color: Colors.black),
      keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hitung Diskon'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                Icon(Icons.shopping_bag, size: 80, color: Colors.orangeAccent),
                const SizedBox(height: 10),
                Text(
                  'Simulasi Diskon Bertingkat',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        buildTextField(namaController, 'Nama Barang', Icons.label, isNumeric: false),
                        const SizedBox(height: 15),
                        buildTextField(hargaController, 'Harga Barang (Rp)', Icons.money),
                        const SizedBox(height: 15),
                        buildTextField(diskonController, 'Diskon Pertama (%)', Icons.percent),
                        const SizedBox(height: 15),
                        buildTextField(diskonKeduaController, 'Diskon Kedua (%) (Opsional)', Icons.percent),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: hitungDiskon,
                              icon: const Icon(Icons.calculate),
                              label: const Text('Hitung'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: reset,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HasilPage extends StatelessWidget {
  final String namaBarang;
  final double harga;
  final double diskon;
  final double potongan;
  final double hargaAkhir;
  final double? diskonKedua;
  final double? potonganKedua;

  HasilPage({
    required this.namaBarang,
    required this.harga,
    required this.diskon,
    required this.potongan,
    required this.hargaAkhir,
    this.diskonKedua,
    this.potonganKedua,
  });

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  String getHasilText() {
    return '''
Barang: $namaBarang
Harga Awal: ${currencyFormat.format(harga)}
Diskon Pertama: ${diskon.toStringAsFixed(2)}%
Potongan Pertama: ${currencyFormat.format(potongan)}
${(diskonKedua != null && diskonKedua! > 0) ? 'Diskon Kedua: ${diskonKedua!.toStringAsFixed(2)}%\nPotongan Kedua: ${currencyFormat.format(potonganKedua)}\n' : ''}Harga Akhir: ${currencyFormat.format(hargaAkhir)}
''';
  }

  void salinHasil(BuildContext context) {
    Clipboard.setData(ClipboardData(text: getHasilText().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Hasil berhasil disalin ke clipboard')),
    );
  }

  void shareWhatsApp(BuildContext context) async {
    final encodedMessage = Uri.encodeComponent(getHasilText());
    final url = Uri.parse("https://wa.me/?text=$encodedMessage");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal membuka WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Perhitungan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Barang: $namaBarang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Harga Awal: ${currencyFormat.format(harga)}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Diskon Pertama: ${diskon.toStringAsFixed(2)}%',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Potongan Pertama: ${currencyFormat.format(potongan)}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    if (diskonKedua != null && diskonKedua! > 0) ...[
                      ListTile(
                        title: Text(
                          'Diskon Kedua: ${diskonKedua!.toStringAsFixed(2)}%',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Potongan Kedua: ${currencyFormat.format(potonganKedua)}',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ],
                    ListTile(
                      title: Text(
                        'Harga Akhir: ${currencyFormat.format(hargaAkhir)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => salinHasil(context),
                          icon: const Icon(Icons.copy),
                          label: const Text('Salin Hasil'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => shareWhatsApp(context),
                          icon: const Icon(Icons.share),
                          label: const Text('WhatsApp'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}