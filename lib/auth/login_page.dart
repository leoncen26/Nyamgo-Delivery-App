import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/admin/admin_page.dart';
import 'package:nyamgo/auth/register_page.dart';
import 'package:nyamgo/component/my_card.dart';
import 'package:nyamgo/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double? deviceHeight, deviceWidth;
  Firestore? firestore = Firestore();
  bool _obscureText = true;

  // @override
  // void dispose() {
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: loginPageUI(),
          ),
        ),
      ),
    );
  }

  Widget loginPageUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        loginTitle(),
        inputForm(),
      ],
    );
  }

  Widget loginTitle() {
    return Column(
      children: [
        // Container(
        //   height: 80,
        //   width: 80,
        //   decoration: const BoxDecoration(
        //     color: Colors.blue,
        //     shape: BoxShape.circle,
        //   ),
        //   child: const Icon(
        //     Icons.person,
        //     color: Colors.white,
        //     size: 50,
        //   ),
        // ),
        MyCard(
            child: Image.asset(
          'assets/images/logo.png',
          height: 60,
          width: 60,
        )),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please Login to Your Account',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget inputForm() {
    return Container(
      //color: Colors.green,
      height: deviceHeight! * 0.68,
      width: deviceWidth! * 0.90,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            emailTextField(),
            const SizedBox(height: 20),
            passwordTextField(),
            forgotPassword(),
            //const SizedBox(height: 10),
            loginButton(),
            const SizedBox(height: 15),
            registerLink(),
            const SizedBox(height: 15),
            orDivider(),
            const SizedBox(height: 15),
            socialLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2))
          ]),
      child: TextFormField(
        controller: _emailController,
        autocorrect: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          bool result = value.contains(
            RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
          );
          if (result) {
            return null;
          } else {
            return 'Please enter a valid email';
          }
        },
        decoration: InputDecoration(
          hintText: 'email',
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2))
          ]),
      child: TextFormField(
        controller: _passwordController,
        autocorrect: false,
        obscureText: _obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must contain 6 letter';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: 'password',
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: deviceHeight! * 0.075,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffFA4A0C),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String email = _emailController.text.trim();
            String password = _passwordController.text;
            bool result =
                await firestore!.loginUser(email: email, password: password);
            if (result) {
              String role = firestore!.currentUser!['role'];
              if (role == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const AdminPage();
                    },
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const MainPage();
                    },
                  ),
                );
              }
            } else {
              // Tambahkan feedback ke pengguna
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login gagal. Email atau password salah.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: const Text(
          'login',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget registerLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Dont Have an Account?',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const RegisterPage();
            }));
          },
          child: const Text('Register Now'),
        ),
      ],
    );
  }

  Widget orDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget socialButton(String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget socialLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        socialButton('assets/images/google.png', () {}),
        socialButton('assets/images/facebook.png', () {}),
        socialButton('assets/images/apple.png', () {}),
      ],
    );
  }
}
