import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'tempat_page.dart';
import 'menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan di masing-masing tab
  static const List<Widget> _pages = <Widget>[
    ProfilePage(),
    TempatPage(),
    MenuPage(),
  ];

  // Fungsi untuk mengganti halaman sesuai dengan tab yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk logout dan kembali ke halaman login
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Hapus token dari SharedPreferences
    await prefs.setBool(
        'is_logged_in', false); // Tandai bahwa pengguna sudah logout

    // Arahkan kembali ke halaman login setelah logout
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pikam Apps'),
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Ketika tombol logout ditekan
          ),
        ],
      ),
      body:
          _pages[_selectedIndex], // Menampilkan halaman sesuai dengan index tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Tempat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex, // Menunjukkan tab yang aktif
        selectedItemColor: Colors.blue, // Warna tab yang aktif
        onTap: _onItemTapped, // Mengganti halaman saat tab dipilih
      ),
    );
  }
}
