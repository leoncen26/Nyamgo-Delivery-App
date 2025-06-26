import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyamgo/Services/firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String searchquery = '';
  Firestore firestore = Firestore();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchquery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final authProvider = Provider.of<AuthProvider>(context);
    // if (!authProvider.isLoggedIn) {
    //   return const Center(child: Text("Silakan login terlebih dahulu"));
    // }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: searchBar(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getItem(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // final List data = snapshot.data!.docs.map((e) => e.data()).toList();
            final List data = snapshot.data!.docs.map((e) => e.data()).toList();
            final allItem = data
                .where((items) => items['name']
                    .toLowerCase()
                    .contains(searchquery.toLowerCase()))
                .toList();

            if (allItem.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 112.0,
                      color: Colors.grey,
                    ),
                    Text(
                      'Item not found',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'Try to search item with different keyword',
                      style: TextStyle(color: Colors.grey, fontSize: 17,),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: allItem.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = allItem[index];
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    item['image'],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    NumberFormat.simpleCurrency(locale: 'en_US')
                                        .format(newPrice),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        //focusNode: searchFocus,
        autofocus: false,
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          filled: true,
          prefixIcon: const Icon(Icons.search),
          fillColor: const Color.fromARGB(255, 245, 245, 245),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
