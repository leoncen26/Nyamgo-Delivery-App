import 'package:flutter/material.dart';
import 'package:nyamgo/auth/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  //double? deviceHeight, deviceWidth;

  @override
  Widget build(BuildContext context) {
    // deviceHeight = MediaQuery.of(context).size.height;
    // deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFF4B3A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logoApp(),
          welcomeImage(),
          const SizedBox(height: 220),
          buttonGetStarted(),
        ],
      ),
    );
  }

  Widget logoApp() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Food for' '\n' 'Everyone',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeImage() {
    return SizedBox(
      width: 400,
      height: 50,
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: SizedBox(
          // PENTING: beri ukuran tetap
          width: 500, // Lebih lebar dari container agar -left bisa muncul
          height: 150,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 150,
                top: -50,
                child: Image.asset(
                  'assets/images/ToyFaces_Tansparent_BG_29.png',
                  width: 350,
                  height: 350,
                ),
              ),
              Positioned(
                left: -60,
                top: -50,
                child: Image.asset(
                  'assets/images/ToyFaces_Tansparent_BG_49.png',
                  width: 350,
                  height: 350,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonGetStarted() {
    return Builder(builder: (context) {
      return Center(
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4B3A).withOpacity(0.8), 
              spreadRadius: 50,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(314, 70)),
            onPressed: () {
              Navigator.pushReplacement((context),
                  MaterialPageRoute(builder: (BuildContext context) {
                return const LoginPage();
              }));
            },
            child: const Text(
              'Get Started',
              style: TextStyle(
                color: Color(0xFFFF4B3A),
              ),
            ),
          ),
        ),
      );
    });
  }
}
