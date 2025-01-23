import 'package:flutter/material.dart';
import 'payment_page.dart'; // Pastikan Anda mengimpor halaman PaymentPage di sini

class TempatPage extends StatefulWidget {
  const TempatPage({super.key});

  @override
  _TempatPageState createState() => _TempatPageState();
}

class _TempatPageState extends State<TempatPage> {
  List<bool> _bookedStatusMeja = List.generate(24, (index) => false);
  List<bool> _bookedStatusKursi = List.generate(24, (index) => false);

  void _toggleBookingMeja(int index) {
    setState(() {
      _bookedStatusMeja[index] = !_bookedStatusMeja[index];
    });
  }

  void _toggleBookingKursi(int index) {
    setState(() {
      _bookedStatusKursi[index] = !_bookedStatusKursi[index];
    });
  }

  bool _isAnySelected() {
    // Mengecek apakah ada meja dan kursi yang dipilih
    return _bookedStatusMeja.contains(true) &&
        _bookedStatusKursi.contains(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSection(
                        'Meja', _bookedStatusMeja, _toggleBookingMeja),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildSection(
                        'Kursi', _bookedStatusKursi, _toggleBookingKursi),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isAnySelected()) _buildPayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<bool> bookedStatus, Function(int) toggleBooking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 1.2,
              ),
              itemCount: bookedStatus.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => toggleBooking(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          bookedStatus[index] ? Colors.red : Colors.brown[300],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Tombol "Bayar" yang akan muncul ketika meja dan kursi dipilih
  Widget _buildPayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Total yang bisa dihitung berdasarkan pilihan meja dan kursi, di sini diasumsikan Rp 100.000
          double totalPrice = 100000;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(totalPrice: totalPrice),
            ),
          );
        },
        child: const Text('Bayar'),
      ),
    );
  }
}
