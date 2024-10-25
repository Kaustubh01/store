import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/components/custom_textbox.dart';
import 'package:store/models/user_model.dart';
import 'package:store/pages/store_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _signUpUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      _showSnackbar("Name and Email are required");
      return;
    }

    UserModel newUser = UserModel(
      id: '', // Firestore will auto-generate this
      name: name,
      email: email,
      role: 'customer', // Default role
      createdAt: Timestamp.now(),
    );

    try {
      await FirebaseFirestore.instance.collection('users').add(newUser.toFirestore());
      _showSnackbar("User registered successfully");
      _nameController.clear();
      _emailController.clear();
      
      // Navigate to StorePage after successful signup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StorePage()),
      );
    } catch (e) {
      _showSnackbar("Failed to register user: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextBox(
              controller: _nameController,
              labelText: 'Name',
            ),
            CustomTextBox(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpUser,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
