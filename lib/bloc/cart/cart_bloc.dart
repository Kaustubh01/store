import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/cart/cart_event.dart';
import 'package:store/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: {})) {
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  void _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(event.itemId)) {
      final existingItem = updatedItems[event.itemId]!;
      updatedItems[event.itemId] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      updatedItems[event.itemId] = CartItem(
        itemId: event.itemId,
        itemName: event.itemName,
        itemPrice: event.itemPrice,
        quantity: event.quantity,
      );
    }

    final newTotalPrice = updatedItems.values.fold(0.0, (total, item) => total + item.itemPrice * item.quantity);
    emit(state.copyWith(items: updatedItems, totalPrice: newTotalPrice));
  }

  void _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) {
    final updatedItems = Map<String, CartItem>.from(state.items);
    updatedItems.remove(event.itemId);

    final newTotalPrice = updatedItems.values.fold(0.0, (total, item) => total + item.itemPrice * item.quantity);
    emit(state.copyWith(items: updatedItems, totalPrice: newTotalPrice));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: {}, totalPrice: 0.0));
  }
}
