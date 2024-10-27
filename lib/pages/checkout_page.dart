import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          
          
        }, child: const Text("Pay using PayPal"),),
      ),
    );
  }
}