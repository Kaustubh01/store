import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/components/custom_textbox.dart';
import 'package:store/models/inventory_model.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CollectionReference inventoryCollection =
      FirebaseFirestore.instance.collection('inventory');
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;
  List<InventoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchInventoryItems();
  }

  Future<void> _fetchInventoryItems() async {
    QuerySnapshot snapshot = await inventoryCollection.get();
    setState(() {
      _items = snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();
    });
  }

  Future<void> _showAddItemDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextBox(controller: nameController, labelText: 'Product Name'),
                CustomTextBox(controller: categoryController, labelText: 'Category'),
                CustomTextBox(controller: sizeController, labelText: 'Size'),
                CustomTextBox(controller: colorController, labelText: 'Color'),
                CustomTextBox(controller: quantityController, labelText: 'Quantity', keyboardType: TextInputType.number),
                CustomTextBox(controller: priceController, labelText: 'Price', keyboardType: TextInputType.number),
                CustomTextBox(controller: descriptionController, labelText: 'Description'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text("Add Image"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addItem();
                Navigator.pop(context); // Close dialog after saving
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUrl = await _uploadImage(pickedFile);
    }
  }

  Future<void> _addItem() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add an image")),
      );
      return;
    }
    try {
      InventoryItem newItem = InventoryItem(
        id: '',
        name: nameController.text,
        category: categoryController.text,
        size: sizeController.text,
        color: colorController.text,
        quantity: int.tryParse(quantityController.text) ?? 0,
        price: double.tryParse(priceController.text) ?? 0.0,
        imageUrl: imageUrl!,
        description: descriptionController.text,
        createdAt: Timestamp.now(),
      );

      await inventoryCollection.add(newItem.toFirestore());
      _fetchInventoryItems(); // Refresh the inventory list
      _clearFields(); // Clear fields after adding item
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add item: $e")),
      );
    }
  }

  Future<String> _uploadImage(XFile image) async {
    String fileName = image.name;
    Reference storageRef = FirebaseStorage.instance.ref().child('inventory/$fileName');
    await storageRef.putFile(File(image.path));
    return await storageRef.getDownloadURL();
  }

  void _clearFields() {
    nameController.clear();
    categoryController.clear();
    sizeController.clear();
    colorController.clear();
    quantityController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrl = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            leading: item.imageUrl.isNotEmpty
                ? Image.network(item.imageUrl, width: 50, height: 50)
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}
