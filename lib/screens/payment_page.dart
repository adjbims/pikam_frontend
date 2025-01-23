import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodOptions(),
            const SizedBox(height: 24),
            _buildTotalPrice(),
            const Spacer(),
            _buildPayNowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOptions() {
    final paymentMethods = ['Credit Card', 'Bank Transfer', 'E-Wallet'];

    return Column(
      children: paymentMethods.map((method) {
        return ListTile(
          title: Text(method),
          leading: Radio<String>(
            value: method,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Pembayaran:',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Rp ${widget.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _confirmPayment();
        },
        child: const Text('Bayar Sekarang'),
      ),
    );
  }

  void _confirmPayment() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pembayaran'),
          content: Text(
              'Anda akan melakukan pembayaran sebesar Rp ${widget.totalPrice.toStringAsFixed(0)} menggunakan $_selectedPaymentMethod.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aksi pembayaran selesai, bisa menambahkan navigasi ke halaman sukses pembayaran
                _showPaymentSuccess();
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
