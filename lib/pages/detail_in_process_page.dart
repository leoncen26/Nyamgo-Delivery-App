import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyamgo/Services/firestore.dart';

class DetailInProcessPage extends StatefulWidget {
  final String orderId;
  const DetailInProcessPage({super.key, required this.orderId});

  @override
  State<DetailInProcessPage> createState() => _DetailInProcessPageState();
}

class _DetailInProcessPageState extends State<DetailInProcessPage> {
  Firestore firestore = Firestore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Detail In Process',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFA4A0C),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: streamInProcessDetail(),
          ),
          buttonStatusOrder(),
        ],
      )),
    );
  }


  Widget streamInProcessDetail() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.db
          .collection('order')
          .where('orderId', isEqualTo: widget.orderId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs
              .map((e) => e.data() as Map<String, dynamic>)
              .toList();

          if (data.isEmpty) {
            return const Center(child: Text('Order tidak ditemukan.'));
          }

          final order = data.first;
          final items = List<Map<String, dynamic>>.from(order['items']);
          final timestamp = (order['createdAt'] as Timestamp).toDate();
          final formattedDate =
              DateFormat('dd MMMM yyyy - HH:mm').format(timestamp);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order['orderId']}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Status: ${order['status']}"),
                        Text("Tanggal: $formattedDate"),
                        const Divider(),
                        Text("Metode Pengiriman: ${order['deliveryMethod']}"),
                        Text("Metode Pembayaran: ${order['paymentMethod']}"),
                        const SizedBox(height: 8),
                        Text("Alamat: ${order['address'] ?? '-'}"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Item Pesanan:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...items.map((item) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: item['image'] != null
                            ? Image.network(item['image'],
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(item['name']),
                        subtitle: Text("Kategori: ${item['category']}"),
                        trailing: Text("\$${item['price']}"),
                      ),
                    )),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total: \$${order['total'].toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buttonStatusOrder() {
    return ElevatedButton(
        onPressed: () async {
          await firestore.db.collection('order').doc(widget.orderId).update({
            'status': 'Pesanan Selesai',
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pesanan Status: Selesai')));
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(350, 60),
          backgroundColor: const Color(0xffFA4A0C),
        ),
        child: const Text(
          'Selesaikan Pesanan',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }
}
