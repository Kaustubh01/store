import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/cart_bloc.dart';
import 'package:store/bloc/cart_event.dart';
import 'package:store/bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text('Total: ${state.totalPrice.toStringAsFixed(1)}\$'),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.items.values.toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text('Price: \$${item.itemPrice} x ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => context.read<CartBloc>().add(RemoveItemFromCart(itemId: item.itemId)),
                      ),
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add checkout functionality here
                      },
                      child: const Text("Checkout"),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () => context.read<CartBloc>().add(ClearCart()),
                      child: const Text('Clear Cart'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
