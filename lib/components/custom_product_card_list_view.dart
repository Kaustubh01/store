import 'package:flutter/material.dart';
import 'package:store/components/custom_card.dart';

class CustomProductCardListView extends StatelessWidget {
  final String title;
  final List<ProductCard> items;

  const CustomProductCardListView({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap in SingleChildScrollView to handle overflow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200, // Fixed height to ensure the ListView fits within
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 160, // Adjust width as needed for each card
                    child:items[index], // Directly use the Card widget
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
