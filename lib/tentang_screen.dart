import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.discount, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              'Tentang Aplikasi Penghitung Diskon',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aplikasi ini dirancang untuk membantu pengguna menghitung harga akhir setelah diskon satu atau dua tingkat diberikan pada suatu produk. '
                  'Cukup masukkan nama barang, harga awal, dan persentase diskon. Aplikasi ini akan menghitung dan menampilkan potongan serta harga akhirnya secara otomatis.\n\n'
                  'Fitur:\n'
                  '• Dukungan dua diskon bertingkat\n'
                  '• Tampilan yang interaktif dan ramah pengguna\n'
                  '• Reset input dengan sekali klik\n'
                  '• Navigasi hasil perhitungan yang jelas\n'
                  '• Fitur Salin hasil\n'
                  '• Share via Whatsapp\n',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
