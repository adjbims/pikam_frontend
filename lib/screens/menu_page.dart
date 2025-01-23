import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Jumlah tab yang kamu inginkan
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Makanan'),
              Tab(text: 'Minuman'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SemuaMenuTab(), // Halaman Semua
            MakananMenuTab(), // Halaman Makanan
            MinumanMenuTab(), // Halaman Minuman
          ],
        ),
      ),
    );
  }
}

// Tab Semua

class SemuaMenuTab extends StatefulWidget {
  const SemuaMenuTab({super.key});

  @override
  _SemuaMenuTabState createState() => _SemuaMenuTabState();
}

class _SemuaMenuTabState extends State<SemuaMenuTab> {
  List<Map<String, dynamic>> _menuData = [];

  @override
  void initState() {
    super.initState();
    fetchMenuData().then((data) {
      setState(() {
        _menuData = data;
      });
    });
  }

  // Fungsi untuk memuat semua data dari JSON (tanpa filter)
  Future<List<Map<String, dynamic>>> fetchMenuData() async {
    final String response =
        await rootBundle.loadString('assets/data/menu_data.json');
    final data = json.decode(response);
    return (data['menu'] as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _menuData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _menuData.length,
              itemBuilder: (context, index) {
                final item = _menuData[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bagian kiri untuk gambar (col-4)
                        Container(
                          width: 100, // Ukuran tetap untuk gambar
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Spasi antar kolom
                        // Bagian kanan untuk informasi (col-8)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Judul makanan/minuman
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Harga
                              Text(
                                "Rp ${item['price']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Deskripsi
                              Text(
                                item['description'],
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              // Row untuk tombol plus, minus, dan jumlah
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (item['quantity'] > 0) {
                                          item['quantity']--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    "${item['quantity']}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Tab Makanan
class MakananMenuTab extends StatefulWidget {
  const MakananMenuTab({super.key});

  @override
  _MakananMenuTabState createState() => _MakananMenuTabState();
}

class _MakananMenuTabState extends State<MakananMenuTab> {
  List<Map<String, dynamic>> _makananData = [];

  @override
  void initState() {
    super.initState();
    fetchMenuData('makanan').then((data) {
      setState(() {
        _makananData = data;
      });
    });
  }

  // Fungsi untuk memuat data JSON dan memfilter tipe "makanan"
  Future<List<Map<String, dynamic>>> fetchMenuData(String type) async {
    final String response =
        await rootBundle.loadString('assets/data/menu_data.json');
    final data = json.decode(response);
    return (data['menu'] as List)
        .where((item) => item['type'] == type)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // Fungsi untuk menambah jumlah pesanan
  void _increaseQuantity(int index) {
    setState(() {
      _makananData[index]['quantity']++;
    });
  }

  // Fungsi untuk mengurangi jumlah pesanan
  void _decreaseQuantity(int index) {
    setState(() {
      if (_makananData[index]['quantity'] > 0) {
        _makananData[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _makananData.length,
        itemBuilder: (context, index) {
          final makanan = _makananData[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian kiri untuk gambar (col-4)
                  Container(
                    width: 100, // Ukuran tetap untuk gambar
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(makanan['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar kolom
                  // Bagian kanan untuk informasi (col-8)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul makanan
                        Text(
                          makanan['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Harga makanan
                        Text(
                          "Rp ${makanan['price']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Deskripsi makanan
                        Text(
                          makanan['description'],
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        // Row untuk tombol plus, minus, dan jumlah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decreaseQuantity(index),
                            ),
                            Text(
                              "${makanan['quantity']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _increaseQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tab Minuman
class MinumanMenuTab extends StatefulWidget {
  const MinumanMenuTab({super.key});

  @override
  _MinumanMenuTabState createState() => _MinumanMenuTabState();
}

class _MinumanMenuTabState extends State<MinumanMenuTab> {
  List<Map<String, dynamic>> _minumanData = [];

  @override
  void initState() {
    super.initState();
    fetchMenuData('minuman').then((data) {
      setState(() {
        _minumanData = data;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchMenuData(String type) async {
    final String response =
        await rootBundle.loadString('assets/data/menu_data.json');
    final data = json.decode(response);
    return (data['menu'] as List)
        .where((item) => item['type'] == type)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  void _increaseQuantity(int index) {
    setState(() {
      _minumanData[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_minumanData[index]['quantity'] > 0) {
        _minumanData[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _minumanData.length,
        itemBuilder: (context, index) {
          final minuman = _minumanData[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian kiri untuk gambar (col-4)
                  Container(
                    width: 100, // Ukuran tetap untuk gambar
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(minuman['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar kolom
                  // Bagian kanan untuk informasi (col-8)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul minuman
                        Text(
                          minuman['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Harga minuman
                        Text(
                          "Rp ${minuman['price']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Deskripsi minuman
                        Text(
                          minuman['description'],
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        // Row untuk tombol plus, minus, dan jumlah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decreaseQuantity(index),
                            ),
                            Text(
                              "${minuman['quantity']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _increaseQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
