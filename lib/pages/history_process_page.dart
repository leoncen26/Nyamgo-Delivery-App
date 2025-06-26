import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/component/my_card.dart';

class HistoryProcessPage extends StatefulWidget {
  const HistoryProcessPage({super.key});

  @override
  State<HistoryProcessPage> createState() => _HistoryProcessPageState();
}

class _HistoryProcessPageState extends State<HistoryProcessPage> {
  Firestore firestore = Firestore();
  @override
  Widget build(BuildContext context) {
    return Card(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.getOrderHistory(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
             
              if (snapshot.hasData) {
                final List data =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                if(data.isEmpty){
                  return const Center(child: Text('No History Order'),);
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final orderData = data[index];
                    return MyCard(
                      child: ListTile(
                        title: Text("Order ID: ${orderData['orderId']}"),
                        subtitle: Text("Total: \$${orderData['total']}"),
                        trailing: Text(orderData['status']),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No History Order'),
                );
              }
            }));
  }
}
