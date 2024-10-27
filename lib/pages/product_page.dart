import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/cart_bloc.dart';
import 'package:store/bloc/cart_event.dart';
import 'package:store/models/inventory_model.dart';

class ProductPage extends StatelessWidget {
  final String productId; // Document ID

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('inventory').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading product details"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Product not found"));
          }

          // Use InventoryItem.fromFirestore to parse data
          final product = InventoryItem.fromFirestore(snapshot.data!);

          return Scaffold(
            appBar: AppBar(
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add item to cart by dispatching an event to CartBloc
                        context.read<CartBloc>().add(
                          AddItemToCart(
                            itemId: productId,
                            itemName: product.name,
                            itemPrice: product.price,
                            quantity: 1, // Set quantity as needed
                          ),
                        );

                        // Show a confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${product.name} added to cart")),
                        );
                      },
                      child: const Text("Add to Cart"),
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
