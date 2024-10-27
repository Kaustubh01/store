import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/components/custom_card.dart';
import 'package:store/components/custom_grid.dart';
import 'package:store/components/custom_product_card_list_view.dart';
import 'package:store/models/inventory_model.dart';
import 'package:store/pages/cart_page.dart';
import 'package:store/pages/inventory_management_page.dart'; // Import your InventoryPage

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Store")),
        actions: [
          IconButton(
            onPressed: (){
                        Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                          ),
                        );
            }, 
            icon: const Icon(Icons.shopping_cart)
          )
        ],
        
      ),
      body: Column(
        children: [
          // NEW ARRIVALS List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final newArrivals = snapshot.data!.docs
                    .map((doc) => InventoryItem.fromFirestore(doc))
                    .toList();

                return CustomProductCardListView(
                  title: "NEW ARRIVALS",
                  items: newArrivals.map((item) {
                   return ProductCard(
                      title: item.name,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      description: item.description,
                      productId: item.id, // Use item.id here
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // TRENDING List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final trendingItems = snapshot.data!.docs
                    .map((doc) => InventoryItem.fromFirestore(doc))
                    .toList();

                return CustomProductCardListView(
                  title: "Trending",
                  items: trendingItems.map((item) {
                    return ProductCard(
                      title: item.name,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      description: item.description,
                      productId: item.id, // Use item.id here
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Categories Grid
          CustomGrid(
            items: ["Shoes", "T-Shirt", "Hoodies", "Jeans"], // Modify this as needed
            title: "Categories",
          ),

          ElevatedButton(
            onPressed: () {
              // Navigate to InventoryPage
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => InventoryPage()),
              );
            },
            child: const Text("Go to Inventory Management"),
          ),
        ],
      ),
    );
  }
}
