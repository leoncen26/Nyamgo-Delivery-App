import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyamgo/provider/auth_provider.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/models/items.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController menuName = TextEditingController();
  final TextEditingController menuPrice = TextEditingController();
  String? selectedCategory;
  Firestore firestore = Firestore();
  File? itemImage;

  final List<String> categories = [
    'Foods',
    'Drinks',
    'Snacks',
    'Desserts',
  ];
  @override
  void dispose() {
    super.dispose();
    menuName.dispose();
    menuPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      return const Center(child: Text("Silakan login terlebih dahulu"));
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addMenu,
        backgroundColor: const Color(0xffFA4A0C),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getItem(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            List data = snapshot.data!.docs.map((e) => e.data()).toList();
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                final double newPrice = double.parse(item['price']);
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4), // bayangan ke bawah
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                              item['image'],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'en_US')
                                  .format(newPrice),
                            ),
                            Text(item['category']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        },
      ),
    );
  }

  void addMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder:
              (context, void Function(void Function()) setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: addMenuWidget(setStateDialog),
            );
          });
        });
  }

  Widget addMenuWidget([void Function(void Function())? setStateDialog]) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Menu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          imageItems(setStateDialog),
          const SizedBox(height: 10),
          TextFormField(
            controller: menuName,
            decoration: const InputDecoration(
              hintText: 'Nama Menu',
            ),
          ),
          TextFormField(
            controller: menuPrice,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              //prefixIcon: Icon(Icons.money_off_csred_rounded),
              hintText: 'Price',
            ),
          ),
          DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text('Pilih Kategori'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                    value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  final item = Items(
                    id: '',
                    name: menuName.text.trim(),
                    imagePath: itemImage,
                    imageUrl: null,
                    price: menuPrice.text.trim(),
                    category: selectedCategory ?? '',
                  );
                  print('imagePath: ${itemImage?.path}');
                  await firestore.addItems(item);
                  menuName.clear();
                  menuPrice.clear();
                  setState(() {
                    selectedCategory = null;
                    itemImage = null;
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Item berhasil tersimpan')));
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageItems([void Function(void Function())? setStateDialog]) {
    ImageProvider? imageProvider = itemImage != null
        ? FileImage(itemImage!)
        : const AssetImage('assets/images/vaggie_tomato.png');
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null &&
            result.files.isNotEmpty &&
            result.files.first.path != null) {
          setState(() {
            itemImage = File(result.files.first.path!);
          });
          if (setStateDialog != null) {
            setStateDialog(() {
              itemImage = File(result.files.first.path!);
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selection cancelled.'),
            ),
          );
        }
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider!,
          ),
        ),
      ),
    );
  }
}
