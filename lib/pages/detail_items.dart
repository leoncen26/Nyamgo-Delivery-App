import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/models/items.dart';

class DetailItems extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailItems({super.key, required this.item});

  @override
  State<DetailItems> createState() => _DetailItemsState();
}

class _DetailItemsState extends State<DetailItems> {
  Firestore firestore = Firestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        widget.item['image'],
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.item['name'],
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${widget.item['price']}',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFA4A0C),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50.0, top: 25.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Info',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Delivery only available before 10.00 PM',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Return Policy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
                backgroundColor: const Color(0xFFFA4A0C),
              ),
              onPressed: () async {
                final userId = firestore.auth.currentUser!.uid;
                await firestore.addToCart(
                    Items(
                      id: widget.item['id'],
                      name: widget.item['name'],
                      imagePath: null,
                      imageUrl: widget.item['image'],
                      price: widget.item['price'],
                      category: widget.item['category'],
                    ),
                    userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Item berhasil tersimpan')));
              },
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
