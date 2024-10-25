import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  final List<String> items;
  final String title;

  const CustomGrid({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        
        mainAxisSize: MainAxisSize.min, // Allow Column to take only the necessary height
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          GridView.builder(
            shrinkWrap: true, // Shrink the GridView to fit its content
            physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 2.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    items[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
