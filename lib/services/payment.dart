import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;
  String? _transferDetails;

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('payment_proofs/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(_image!);
      await uploadTask.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        print("Image uploaded! Download URL: $downloadUrl");
        // You can save the downloadUrl to your database here
      });
    } catch (e) {
      print("Failed to upload image: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.primary, // Background color
      appBar: AppBar(
        title: Text('Payment Page'),
        backgroundColor: ColorStyles.primary,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: Colors.white, // White background for the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Transfer Details',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _transferDetails = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter transfer details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _image == null
                        ? Text('No image selected.')
                        : Image.file(_image!),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyles.primary, // Button color
                      ),
                      child: Text('Pick Image'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _uploadImage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyles.primary, // Button color
                      ),
                      child: Text('Upload Payment Proof'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
