import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryButtonColor = Color(0xFFCF9E7C);
const Color textColor = Colors.white;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEnv();
    _checkLoginStatus();
  }

  Future<void> _loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  bool _validateInputs() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (_usernameController.text.isEmpty) {
      _showErrorDialog('Username tidak boleh kosong');
      return false;
    }

    if (_fullnameController.text.isEmpty) {
      _showErrorDialog('Nama lengkap tidak boleh kosong');
      return false;
    }

    if (_emailController.text.isEmpty) {
      _showErrorDialog('Email tidak boleh kosong');
      return false;
    }

    if (!emailRegex.hasMatch(_emailController.text)) {
      _showErrorDialog('Format email tidak valid');
      return false;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Password tidak boleh kosong');
      return false;
    }

    if (_passwordController.text.length < 6) {
      _showErrorDialog('Password harus minimal 6 karakter');
      return false;
    }

    return true;
  }

  Future<void> _register() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    if (apiBaseUrl == null) {
      _showErrorDialog('API_BASE_URL tidak ditemukan di file .env');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$apiBaseUrl/registrasi');
    final body = {
      "customer_username": _usernameController.text,
      "customer_full_name": _fullnameController.text,
      "customer_email": _emailController.text,
      "customer_password": _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data']['customer_uuid'] != null) {
          String token = data['data']['customer_uuid'];
          await _saveLoginSession(token);
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showErrorDialog(data['message'] ?? 'Registrasi gagal');
        }
      } else {
        _showErrorDialog('Registrasi gagal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  Future<void> _saveLoginSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setBool('is_logged_in', true);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo-pikam.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'Register',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: textColor)
                          : const Text('Register', style: TextStyle(fontSize: 16, color: textColor)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Sudah punya akun? Login', style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}