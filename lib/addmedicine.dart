import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineDescController = TextEditingController();
  final TextEditingController _medicinePriceController = TextEditingController();
  final CollectionReference medicines = FirebaseFirestore.instance.collection('AddMedicine');

  void _showAlert(String message, {bool shouldGoBack = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (shouldGoBack) {
                  Navigator.pop(context); // 🚀 Sirf ek step wapas jaye
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addMedicine() {
    String medicineTitle = _medicineNameController.text.trim();
    String desc = _medicineDescController.text.trim();
    String priceText = _medicinePriceController.text.trim();

    if (medicineTitle.isEmpty || desc.isEmpty || priceText.isEmpty) {
      _showAlert("All fields are required!");
      return Future.value();
    }

    int? price = int.tryParse(priceText);
    if (price == null) {
      _showAlert("Invalid price! Enter a valid number.");
      return Future.value();
    }

    return medicines.add({
      'Title': medicineTitle,
      'Description': desc,
      'Price': price
    }).then((_) {
      _showAlert("Medicine added successfully!", shouldGoBack: true);
    }).catchError((error) {
      _showAlert("Failed to add medicine: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: "Medicine Name",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _medicineDescController,
                decoration: const InputDecoration(
                  labelText: "Medicine Description",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _medicinePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Medicine Price",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: addMedicine, 
                child: const Text("Add Medicine")
              ),
            )
          ],
        ),
      ),
    );
  }
}