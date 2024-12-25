import 'dart:io';

import 'package:finalproject2/model/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/items_data.dart';
import 'cart.dart';
import 'new_item.dart';
import 'product_detail.dart';

enum Mode { create, edit }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Items> _disPlayItem = allItem;
  List<OrderItems> _orderList = []; // List to store cart items (OrderItems)
  Set<Items> _selectedItems = {}; // Set to track selected items

  // Add new Items
  Future<void> _addItem() async {
    final newItem = await Navigator.of(context).push<Items>(
      MaterialPageRoute(
        builder: (ctx) => const AddNewItems(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _disPlayItem.add(newItem);
      });
    }
  }

  // Add product to cart
  Future<void> _addToCart(Items item) async {
    final existingItem =
    _orderList.indexWhere((orderItem) => orderItem.name == item.name);
    if (existingItem != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} is already in the cart!'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final newItem = await Navigator.of(context).push<OrderItems?>(
      MaterialPageRoute(
        builder: (ctx) => ProductDetailPage(item: item),
      ),
    );
    if (newItem != null) {
      setState(() {
        _orderList.add(newItem);
      });
    }
  }

  // View items in cart
  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Cartpage(orderItems: _orderList), // Pass _orderList to CartPage
      ),
    );
  }

  // Edit item
  Future<void> _editItem(Items item) async {
    final updatedItem = await Navigator.push<Items>(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddNewItems(item: item, mode: Mode.edit),
      ),
    );
    if (updatedItem != null) {
      setState(() {
        final index =
        _disPlayItem.indexWhere((g) => g.name == item.name);
        if (index != -1) {
          _disPlayItem[index] = updatedItem;
        }
      });
    }
  }

  // Remove selected items
  void _removeSelectedItems() {
    setState(() {
      _disPlayItem.removeWhere((item) => _selectedItems.contains(item));
      _selectedItems.clear(); // Clear the selection after deletion
    });
  }

  // Toggle selection state
  void _toggleSelection(Items item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: navigateToCart,
          ),
          IconButton(
            onPressed: _removeSelectedItems,
            icon: const Icon(Icons.delete),
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Available Items",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _disPlayItem.map((item) {
                  return GestureDetector(
                    onTap: () {
                      _addToCart(item);
                    },
                    onLongPress: () {
                      _editItem(item);
                    },
                    onDoubleTap: () {
                      _toggleSelection(item); // Toggle selection on double tap
                    },
                    child: Container(
                      width: 250,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: _selectedItems.contains(item)
                              ? Colors.blueAccent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Price: \$${item.price}',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Qty: ${item.qty}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
