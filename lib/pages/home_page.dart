import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyamgo/pages/category_items.dart';
import 'package:nyamgo/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String searchquery = '';
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchquery = searchController.text;
      });
    });
    // searchFocus.addListener(() {
    //   if (!searchFocus.hasFocus) {
    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          //backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleHome(),
                  const SizedBox(height: 20),
                  searchBar(),
                  tabBarKategori(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleHome() {
    return const Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        'Delicious' '\n' 'Food for you',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget searchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Text("Search..."),
          ],
        ),
      ),
    );
  }

  Widget tabBarKategori() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TabBar(
            indicatorColor: Colors.red,
            isScrollable: true,
            dividerColor: Colors.transparent,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Foods',
              ),
              Tab(
                text: 'Drinks',
              ),
              Tab(
                text: 'Snacks',
              ),
              Tab(
                text: 'Desserts',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'See More',
                  style: TextStyle(
                      color: Color(0xFFFF4B3A), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(
                  child: CategoryItems(
                    category: 'Foods',
                    searchQuery: searchquery,
                  ),
                ),
                Center(
                  child: CategoryItems(
                      category: 'Drinks', searchQuery: searchquery),
                ),
                Center(
                  child: Text('Daftar Cemilan'),
                ),
                Center(
                  child: CategoryItems(category: 'Desserts', searchQuery: searchquery),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
