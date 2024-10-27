import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final Map<String, CartItem> items;
  final double totalPrice;

  CartState({required this.items, this.totalPrice = 0.0});

  CartState copyWith({Map<String, CartItem>? items, double? totalPrice}) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object> get props => [items, totalPrice];
}

class CartItem extends Equatable {
  final String itemId;
  final String itemName;
  final double itemPrice;
  final int quantity;

  CartItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      itemId: itemId,
      itemName: itemName,
      itemPrice: itemPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [itemId, itemName, itemPrice, quantity];
}
