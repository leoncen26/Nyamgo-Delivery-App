import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/admin/admin_order_page.dart';
import 'package:nyamgo/admin/menu_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selectedItem = 0;
  List pages = [
    const MenuPage(),
    const AdminOrderPage(),
  ];

  void navigateBottomNav(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  Firestore firestore = Firestore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFA4A0C),
        title: const Text('Admin Page', style: TextStyle(color: Colors.white, fontSize: 18),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await firestore.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.logout, color: Colors.white,))
        ],
      ),
      body: pages[selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => navigateBottomNav(index),
        currentIndex: selectedItem,
        fixedColor: const Color(0xffFA4A0C),
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.restaurant_menu_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
