import 'package:flutter/material.dart';
import 'package:nyamgo/pages/history_process_page.dart';
import 'package:nyamgo/pages/in_process_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  TabController? tabHistoryController;

  @override
  void initState() {
    super.initState();
    tabHistoryController =
        TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    tabHistoryController!.dispose();
  }

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
          ),
        ),
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFA4A0C),
        bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            controller: tabHistoryController,
            tabs: const [
              Tab(
                text: 'Dalam Proses',
              ),
              Tab(
                text: 'History',
              ),
            ]),
      ),
      body: TabBarViewWidget(),
    );
  }

  Widget TabBarViewWidget() {
    return TabBarView(controller: tabHistoryController, children: [
      InProcessPage(),
      HistoryProcessPage(),
    ]);
  }
}
