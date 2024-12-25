import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../model/list_item.dart';
import 'home_page.dart';

class AddNewItems extends StatefulWidget {
  final Items? item;
  final Mode mode;


  const AddNewItems({super.key, this.item , this.mode = Mode.create});

  @override
  State<AddNewItems> createState() => _NewItemState();
}

class _NewItemState extends State<AddNewItems> {
  final _formKey = GlobalKey<FormState>();

  String _enteredName = '';
  int _enteredQuantity = 1;
  double _enteredPrice = 5.0;


  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(
        context,
        Items(
          name: _enteredName,
          price: _enteredPrice,
          qty: _enteredQuantity,
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.edit) {
      _enteredName = widget.item!.name;
      _enteredPrice = widget.item!.price;
      _enteredQuantity = widget.item!.qty;
    }
  }
      String? _validateName(String? value) {
    if (value == null || value.isEmpty || value.trim().length > 50) {
      return 'Name must be between 1 and 50 characters.';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value)! <= 0) {
      return 'Quantity must be a valid positive number.';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null ||
        value.isEmpty ||
        double.tryParse(value) == null ||
        double.tryParse(value)! <= 0) {
      return 'Price must be a valid positive number.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.mode == Mode.edit
        ? const Text('Edit')
        :const Text('Add New Item'),
        actions: [
          widget.mode == Mode.edit?Icon(Icons.edit): Icon(Icons.add)
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: _validateName,
                initialValue: _enteredName,
                decoration: InputDecoration(
                labelText: 'Enter text', // Label for the input field
                hintText: 'Type here...', // Placeholder text
                prefixIcon: Icon(Icons.text_fields), // Optional prefix icon
                filled: true, // Adds a background color
                fillColor: Colors.blue.shade50, // Background color of the input field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blue.shade300, // Border color
                    width: 2, // Border width
                  ),)
              ),
                onSaved: (value) => _enteredName = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: _validatePrice,
                initialValue: _enteredPrice.toString(),
                decoration: InputDecoration(
                    labelText: 'Enter Price', // Label for the input field
                    hintText: 'Type here...', // Placeholder text
                    prefixIcon: Icon(Icons.monetization_on_outlined), // Optional prefix icon
                    filled: true, // Adds a background color
                    fillColor: Colors.blue.shade50, // Background color of the input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.blue.shade300, // Border color
                        width: 2, // Border width
                      ),)
                ),
                onSaved: (value) => _enteredPrice = double.parse(value!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: _validateQuantity,
                initialValue: _enteredQuantity.toString(),
                decoration: InputDecoration(
                    labelText: 'Enter Qty', // Label for the input field
                    hintText: 'Type here...', // Placeholder text
                    prefixIcon: Icon(Icons.square), // Optional prefix icon
                    filled: true, // Adds a background color
                    fillColor: Colors.blue.shade50, // Background color of the input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.blue.shade300, // Border color
                        width: 2, // Border width
                      ),)
                ),
                onSaved: (value) => _enteredQuantity = int.parse(value!),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding
                    elevation: 5, // Shadow effect
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding
                      elevation: 5, // Shadow effect
                    ),
                    child: const Text('Add Item',
                      style: TextStyle(
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
