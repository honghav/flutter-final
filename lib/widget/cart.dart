import 'package:flutter/material.dart';

import '../model/list_item.dart';

class Cartpage extends StatefulWidget {
  final List<OrderItems> orderItems;

  const Cartpage({Key? key, required this.orderItems}) : super(key: key);

  @override
  _CartpageState createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  final List<Orders> orders = [];

  // Calculate total quantity
  int getTotalQuantity() {
    return widget.orderItems.fold(0, (sum, item) => sum + item.qty);
  }

  // Calculate total price
  double getTotalPrice() {
    return widget.orderItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Get current date as a formatted string
  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  // Create a new order and clear the cart
  void createOrder() {
    final date = getCurrentDateTime();
    final items = List<OrderItems>.from(widget.orderItems);
      Navigator.pop(context);
    setState(() {
      // Add the order to the list
      orders.add(Orders(date: date, items: items));
      // Clear the cart
      widget.orderItems.clear();
    });

    print("Order created successfully!");
  }

  // Print all orders to the console
  // void printAllOrders() {
  //   if (orders.isEmpty) {
  //     print("No orders available.");
  //   } else {
  //     print("All Orders:");
  //     for (var order in orders) {
  //       print("Date: ${order.date}");
  //       for (var item in order.items) {
  //         print(
  //             "  Name: ${item.name}, Price: \$${item.price.toStringAsFixed(2)}, Quantity: ${item.qty},");
  //       }
  //     }
  //   }
  // }

  // Remove item from cart
  void removeItem(OrderItems item) {
    setState(() {
      widget.orderItems.remove(item);
    });
  }


  @override
  Widget build(BuildContext context) {
    final totalQuantity = getTotalQuantity();
    final totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: widget.orderItems.isEmpty
          ? const Center(child: Text("Your cart is empty!", style: TextStyle(fontSize: 18)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (context, index) {
                final item = widget.orderItems[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(item.name[0], style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Qty: ${item.qty}, Price: \$${item.price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeItem(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Quantity: $totalQuantity",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (widget.orderItems.isNotEmpty) {
                      createOrder();
                    } else {
                      print("Cart is empty. Cannot create order.");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)
                      ],
                    ),
                    child: const Text(
                      "Place Order",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
