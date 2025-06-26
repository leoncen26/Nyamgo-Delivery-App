import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyamgo/provider/auth_provider.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:intl/intl.dart';
import 'package:nyamgo/auth/login_page.dart';
import 'package:nyamgo/pages/detail_items.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoryItems extends StatelessWidget {
  final String category;
  final String searchQuery;
  CategoryItems({super.key, required this.category, required this.searchQuery});

  Firestore firestore = Firestore();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      return const Center(child: Text("Silakan login terlebih dahulu"));
    }
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.getItem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const LoginPage();
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }
          if (snapshot.hasData) {
            final List data = snapshot.data!.docs.map((e) => e.data()).toList();
            final allItems = data
                .where(
                  (items) =>
                      items['category'] == category &&
                      items['name']
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()),
                )
                .toList();
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              scrollDirection: Axis.horizontal,
              itemCount: allItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = allItems[index];
                final double newPrice = double.parse(item['price']);
                return GestureDetector(
                  onTap: () async {
                    // FocusScope.of(context).unfocus();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return DetailItems(item: item);
                    // }));
                    // FocusScope.of(context).unfocus();
                    FocusScope.of(context).unfocus(); // unfocus
                    SystemChannels.textInput
                        .invokeMethod('TextInput.hide'); // paksa tutup

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailItems(item: item)),
                    );

                    // Saat kembali
                    //FocusScope.of(context).unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  child: SingleChildScrollView(
                    child: Container(
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
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  item['image'],
                                ),
                              ),
                            ),
                          ),
                          Text(item['name']),
                          Text(
                            NumberFormat.simpleCurrency(locale: 'en_US')
                                .format(newPrice),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        });
  }
}
