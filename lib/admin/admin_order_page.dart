import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/admin/admin_detail_order.dart';
import 'package:nyamgo/component/my_card.dart';
import 'package:nyamgo/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({super.key});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  Firestore firestore = Firestore();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if(!authProvider.isLoggedIn){
      return const Center(child: Text("Silakan login terlebih dahulu"));
    }
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: firestore.db
                .collection('order')
                .where('status', isEqualTo: 'Di Proses')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final List data =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final order = data[index];
                    return MyCard(
                      child: ListTile(
                        title: Text("Order ID: ${order['orderId']}"),
                        subtitle: Text("Total: \$${order['total']}"),
                        trailing: Text(order['status']),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AdminDetailOrder(orderId: '${order['orderId']}');
                          }));
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Order'),
                );
              }
            }));
  }

  // Widget getOrderStream(){
  //   return StreamBuilder<QuerySnapshot>(stream: firestore.getOrder(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

  //   }); firestore.db.collection('order').where('status', isEqualTo: 'Di Proses').snapshots()
  // }
}
