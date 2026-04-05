import 'package:dandom/features/auth/data/datasouces/auth_firebase_service.dart';
import 'package:dandom/features/auth/presentation/page/login.dart';
import 'package:dandom/features/auth/presentation/page/mainpage/Home_page.dart';
import 'package:dandom/features/auth/presentation/widget/mainnavigator.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String email = '';
  String username = '';
  String password = '';
  String confirmpassword = '';
  bool loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => loading = true);

    try {
      final userCredential = await _auth.register(email, password);

      // 👇 เพิ่มตรงนี้
      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.reload();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 177, 199, 178),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "กินไรดี ?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "สมัครสมาชิก",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              //USERNAME
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'กรุณากรอกข้อมูล';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "ชื่อผู้ใช้งาน",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onSaved: (v) => username = v ?? '',
                ),
              ),
              const SizedBox(height: 25),

              /// EMAIL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'กรุณากรอกอีเมล';
                    }
                    if (!v.contains('@')) {
                      return 'รูปแบบอีเมลไม่ถูกต้อง';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "อีเมล",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onSaved: (v) => email = v ?? '',
                ),
              ),

              const SizedBox(height: 25),

              /// PASSWORD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'รหัสผ่านต้องอย่างน้อย 6 ตัว';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "รหัสผ่าน",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onSaved: (v) => password = v ?? '',
                ),
              ),

              const SizedBox(height: 25),

              /// CONFIRMPASSWORD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'กรุณายืนยันรหัสผ่าน';
                    }
                    if (v != passwordController.text) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },

                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "ยืนยันรหัสผ่าน",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onSaved: (v) => confirmpassword = v ?? '',
                ),
              ),

              /// REGISTER BUTTON
              SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3F32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "สมัครสมาชิก",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              const Text("มีบัญชีอยู่แล้ว?"),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
