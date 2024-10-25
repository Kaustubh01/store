import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final String imageUrl;
  final String description;
  final Timestamp createdAt;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
  });

  // Convert Firestore Document to InventoryItem object
  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      size: data['size'] ?? '',
      color: data['color'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert InventoryItem object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'size': size,
      'color': color,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
