import 'package:dandom/features/auth/data/datasouces/auth_firebase_service.dart';
import 'package:dandom/features/auth/presentation/page/Signup/sigup.dart';
import 'package:dandom/features/auth/presentation/page/Signup/Email_Verification.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  String email = '';
  String password = '';
  bool loading = false;

 Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  _formKey.currentState!.save();
  setState(() => loading = true);

  try {
    final userCredential = await _auth.login(email, password);

    final user = userCredential.user;

    // รีโหลดข้อมูลล่าสุด
    await user!.reload();

    if (user.emailVerified) {
      // ✅ เข้าแอปได้
      Navigator.of(context).pop();
    } else {
      // ❌ ยังไม่ verify
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ")),
      );

      // 👉 พาไปหน้า verify
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VerifyEmailPage(),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }

  setState(() => loading = false);
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
                "ลงชื่อเข้าใช้",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),

              /// EMAIL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
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
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "รหัสผ่าน",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onSaved: (v) => password = v ?? '',
                ),
              ),

              const SizedBox(height: 80),

              /// LOGIN BUTTON
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
                  onPressed: loading ? null : _login,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              const Text("ไม่มีบัญชี?"),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  );
                },
                child: const Text(
                  "สมัครใช้งาน",
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
