import 'package:flutter/material.dart';
import 'package:nyamgo/pages/cart_page.dart';
import 'package:nyamgo/provider/auth_provider.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/auth/login_page.dart';
import 'package:nyamgo/pages/favorite_page.dart';
import 'package:nyamgo/pages/history_page.dart';
import 'package:nyamgo/pages/home_page.dart';
import 'package:nyamgo/pages/profile_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Firestore firestore = Firestore();
  int selectedIndex = 0;
  final List tabs = [
    const HomePage(),
    const FavoritePage(),
    const ProfilePage(),
    const HistoryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedIndex == 3 || selectedIndex == 2
          ? null
          : AppBar(
              actions: [
                IconButton(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const CartPage();
                    }));
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
      drawer: Drawer(
          child: Container(
        color: const Color(0xFFFF4B3A),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                    child: Center(
                        child: Text(
                  'NyamGo',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ))),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 400),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            )
          ],
        ),
      )),
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: const Color(0xffEDEDED),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        fixedColor: const Color(0xFFFF4B3A),
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.favorite_border,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person_outline_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.history,
            ),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
