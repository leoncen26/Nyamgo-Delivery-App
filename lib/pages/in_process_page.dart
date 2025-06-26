import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/pages/detail_in_process_page.dart';

class InProcessPage extends StatefulWidget {
  const InProcessPage({super.key});

  @override
  State<InProcessPage> createState() => _InProcessPageState();
}

class _InProcessPageState extends State<InProcessPage> {
  Firestore firestore = Firestore();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: inProcessOrder(),
    );
  }

  Widget inProcessOrder() {
    return StreamBuilder(
        stream: firestore.db
            .collection('order')
            .where('status', isEqualTo: 'Di Kirim')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List data = snapshot.data!.docs.map((e) => e.data()).toList();
            if(data.isEmpty){
               return const Center(child: Text('There is no In Process Order'));
            }
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final orderData = data[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text("Order ID: ${orderData['orderId']}"),
                      subtitle: Text("Total: \$${orderData['total']}"),
                      trailing: Text(orderData['status']),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return DetailInProcessPage(orderId: orderData['orderId']);
                        }));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('Tidak ada order dalam Proses'),
            );
          }
        });
  }
}
