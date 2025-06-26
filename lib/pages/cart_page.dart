import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/component/my_card.dart';
import 'package:nyamgo/models/items.dart';
import 'package:nyamgo/pages/payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Firestore firestore = Firestore();
  List<Items> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: streamCart(),
            ),
          ),
          buttonCart(),
        ],
      )),
    );
  }

  Widget streamCart() {
    String userId = firestore.auth.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getCart(userId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List data = snapshot.data!.docs.map((e) => e.data()).toList();
          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 112,
                    color: Colors.grey
                  ),
                  Text(
                    'No Item in Cart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = data[index];
                final newPrice = double.parse(item['price']);
                return MyCard(
                  child: Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final userId =
                                      firestore.auth.currentUser!.uid;
                                  await firestore.deleteCart(
                                      userId, item['id']);
                                  Fluttertoast.showToast(
                                    msg: "Item dihapus dari Cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              )
                            ]),
                        child: ListTile(
                          leading: item['image'] != null
                              ? Image.network(
                                  item['image'],
                                  width: 100,
                                  height: 100,
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(item['name']),
                          subtitle: Text(item['category']),
                          trailing: Text('\$$newPrice'),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  int newQuantity = item['quantity'];
                                  final itemId = item['id'];
                                  firestore.updateQuantityCart(
                                      userId, itemId, newQuantity - 1);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                )),
                            Text(item['quantity'].toString()),
                            IconButton(
                              onPressed: () {
                                int newQuantity = item['quantity'];
                                final itemId = item['id'];
                                firestore.updateQuantityCart(
                                    userId, itemId, newQuantity + 1);
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 112,
                ),
                Text(
                  'No Item in Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buttonCart() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const PaymentPage();
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(350, 60),
        backgroundColor: const Color(0xffFA4A0C),
      ),
      child: const Text(
        'Complete Order',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
