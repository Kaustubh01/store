import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final String title;
  final List<Widget> items; // List of Widget items

  const CustomListView({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 180, // Increased height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 140, // Increased width for each card
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Rounded corners for cards
                    child: items[index], // Directly use the Card widget
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
