import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pert12_auth/service/auth.dart';
import 'package:pert12_auth/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _userData = ''; // Variable to hold fetched data

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFetchData() async {
    setState(() {
      _userData = ''; // Clear previous data
    });

    try {
      final data = await fetchProtectedData();
      setState(() {
        _userData = 'Nama: ${data['name']}\nEmail: ${data['email']}'; // Display the fetched data
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data: $e")),
      );
    }
  }

  void handleHapusToken() async {
    try {
      await logout();
      setState(() {
        _userData = ''; // Clear data when token is removed
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: _isLoading ? "Loading..." : "Login",
              onPressed: _isLoading ? null : handleLogin,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Fetch Data",
              onPressed: handleFetchData,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Hapus Access Token",
              onPressed: handleHapusToken,
            ),
            const SizedBox(height: 20),
            if (_userData.isNotEmpty) ...[
              Text(
                'Data User: $_userData',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}