// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Vechilepage extends StatefulWidget {
  const Vechilepage({super.key});

  @override
  State<Vechilepage> createState() => _VechilepageState();
}

class Vehicle {
  String make;
  String model;
  String year;

  Vehicle({required this.make, required this.model, required this.year});
}

class _VechilepageState extends State<Vechilepage> {
  final _formKey = GlobalKey<FormState>();

  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  bool isFormVisible = false;

  List<Vehicle> vehicles = [];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, create a Vehicle object and add it to the list
      Vehicle vehicle = Vehicle(
        make: _makeController.text,
        model: _modelController.text,
        year: _yearController.text,
      );

      setState(() {
        vehicles.add(vehicle);
        isFormVisible = false; // Hide the form after submission
      });

      // Clear text controllers
      _makeController.clear();
      _modelController.clear();
      _yearController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFormVisible =
                      true; // Show the form when the button is pressed
                });
              },
              child: Text('Add Vehicle'),
            ),
            Visibility(
              visible: isFormVisible,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: InputDecoration(labelText: 'Make'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the make';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(labelText: 'Model'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the model';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the year';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Card(
                    child: ListTile(
                      title: Text('Make: ${vehicle.make}'),
                      subtitle: Text(
                          'Model: ${vehicle.model}, Year: ${vehicle.year}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
