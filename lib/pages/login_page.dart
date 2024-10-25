import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/components/custom_textbox.dart';
import 'package:store/pages/signup_page.dart';
import 'package:store/pages/store_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _loginUser() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar("Email is required");
      return;
    }

    // Check if user exists in Firestore
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _showSnackbar("Login successful");
        _emailController.clear();

        // Navigate to StorePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StorePage()),
        );
      } else {
        _showSnackbar("User not found. Please sign up.");
      }
    } catch (e) {
      _showSnackbar("Failed to login: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextBox(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to SignupPage
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
