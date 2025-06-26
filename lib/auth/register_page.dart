import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nyamgo/pages/main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fullPhoneNumber = '';

  double? deviceHeight, deviceWidth;

  bool _obscureText = true;
  Firestore firestore = Firestore();
  File? profilePicture;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: registerPageUI(),
          ),
        ),
      ),
    );
  }

  Widget registerPageUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        registerTitle(),
        inputFormRegis(),
      ],
    );
  }

  Widget registerTitle() {
    return const Column(
      children: [
        Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
        Text(
          'Please Create Your Account',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget inputFormRegis() {
    return Container(
      //color: Colors.green,
      height: deviceHeight! * 0.70,
      width: deviceWidth! * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profilePicUser(),
            nameTextField(),
            emailTextField(),
            passwordTextField(),
            phoneNumField(),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget profilePicUser() {
    ImageProvider imageProvider = profilePicture != null
        ? FileImage(profilePicture!)
        : const AssetImage('assets/images/default_user.png');
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null &&
            result.files.isNotEmpty &&
            result.files.first.path != null) {
          setState(() {
            profilePicture = File(result.files.first.path!);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selection cancelled.'),
            ),
          );
        }
      },
      child: Container(
        height: deviceHeight! * 0.15,
        width: deviceWidth! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider),
        ),
      ),
    );
  }

  Widget nameTextField() {
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
        controller: _nameController,
        validator: (value) {
          if (value!.length < 4) {
            return 'name must contain atleast 4 letter';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: 'name',
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
          bool result = value!.contains(
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
          if (value!.length < 6) {
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

  Widget phoneNumField() {
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
      child: IntlPhoneField(
        //controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'phone number',
          counterText: '',
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.phone),
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
        initialCountryCode: 'ID',
        onChanged: (phone) {
          fullPhoneNumber = phone.completeNumber;
        },
        validator: (value) {
          if (value == null || value.number.isEmpty) {
            return 'Phone number is required';
          } else if (value.number.length < 9) {
            return 'Enter a valid phone number';
          }
          return null;
        },
      ),
    );
  }

  Widget registerButton() {
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
        onPressed: submitRegisterForm,
        child: const Text(
          'Register',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void submitRegisterForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      String phoneNumber = fullPhoneNumber;
      bool result = await firestore.registerUser(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
        lastLogin: Timestamp.now(),
      );
      if (result) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const MainPage();
          
        }),(Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi gagal.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
