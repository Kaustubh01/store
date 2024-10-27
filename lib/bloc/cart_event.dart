import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddItemToCart extends CartEvent {
  final String itemId;
  final String itemName;
  final double itemPrice;
  final int quantity;

  AddItemToCart({required this.itemId, required this.itemName, required this.itemPrice, this.quantity = 1});

  @override
  List<Object> get props => [itemId, itemName, itemPrice, quantity];
}

class RemoveItemFromCart extends CartEvent {
  final String itemId;

  RemoveItemFromCart({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class ClearCart extends CartEvent {}
