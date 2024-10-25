import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/components/custom_grid.dart';
import 'package:store/components/custom_list_view.dart';
import 'package:store/pages/inventory_management_page.dart'; // Import your InventoryPage

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store"),
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
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return CustomListView(
                  title: "NEW ARRIVALS",
                  items: newArrivals.map((item) {
                    return Card(
                      child: Column(
                        children: [
                          Image.network(item['imageUrl']),
                          Text(item['name']),
                          Text("\$${item['price'].toStringAsFixed(2)}"),
                        ],
                      ),
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
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return CustomListView(
                  title: "Trending",
                  items: trendingItems.map((item) {
                    return Card(
                      child: Column(
                        children: [
                          Image.network(item['imageUrl']),
                          Text(item['name']),
                          Text("\$${item['price'].toStringAsFixed(2)}"),
                        ],
                      ),
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
