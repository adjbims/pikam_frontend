import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'tempat_page.dart'; // Pastikan Anda memiliki TempatPage yang sudah didefinisikan

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> _specialMenuData = [];
  double _totalPrice = 0.0; // Variable untuk total harga keranjang

  @override
  void initState() {
    super.initState();
    _loadSpecialMenuData();
  }

  Future<void> _loadSpecialMenuData() async {
    final String response =
        await rootBundle.loadString('assets/data/menu_data.json');
    final data = json.decode(response);
    final List<Map<String, dynamic>> allItems =
        List<Map<String, dynamic>>.from(data['menu']);

    final foodItems =
        allItems.where((item) => item['type'] == 'makanan').take(2).toList();

    setState(() {
      _specialMenuData = foodItems;
    });
  }

  void _updateTotalPrice() {
    // Menghitung total harga berdasarkan quantity yang ada
    double total = 0.0;
    for (var item in _specialMenuData) {
      total += (item['price'] * (item['quantity'] ?? 0));
    }
    setState(() {
      _totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryIcons(),
            Expanded(child: _buildMenuSpecial()),
          ],
        ),
      ),
      bottomNavigationBar: _buildCheckoutBar(context),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.brown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile_pic.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Halo Users,',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Selamat Datang !',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Menu Favoritmu',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final categories = [
      {'icon': Icons.coffee, 'label': 'Tubruk'},
      {'icon': Icons.coffee_maker, 'label': 'Espresso'},
      {'icon': Icons.local_cafe, 'label': 'Latte'},
      {'icon': Icons.coffee_outlined, 'label': 'Biji'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category['icon'] as IconData, color: Colors.brown),
              ),
              const SizedBox(height: 4),
              Text(category['label'] as String, style: TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuSpecial() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Menu Spesial Untuk Hari ini',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _specialMenuData.length,
              itemBuilder: (context, index) {
                final item = _specialMenuData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side for image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Right side for information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${item['price']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['description'],
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
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
                                          _updateTotalPrice();
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    "${item['quantity'] ?? 0}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity'] =
                                            (item['quantity'] ?? 0) + 1;
                                        _updateTotalPrice();
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
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat bagian bawah untuk checkout
  Widget _buildCheckoutBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: Rp $_totalPrice",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke halaman tempat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TempatPage()),
              );
            },
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
  }
}
