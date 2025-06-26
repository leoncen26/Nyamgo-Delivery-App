import 'package:flutter/material.dart';
import 'package:nyamgo/pages/main_page.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  String _statusMessage = "Pesanan sedang diproses...";
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _statusMessage = "Pesanan berhasil dibuat dan sedang dikirim.";
        _isProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Status Pesanan"),
        backgroundColor: const Color(0xffFA4A0C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isProcessing
                ? const CircularProgressIndicator(
                    color: Color(0xffFA4A0C),
                  )
                : const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 80,
                  ),
            const SizedBox(height: 30),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            if (!_isProcessing)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                    return const MainPage();
                  }), (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFA4A0C),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  "Kembali ke Beranda",
                  style: TextStyle(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}
