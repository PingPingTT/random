import 'package:dandom/model/Register.dart';
import 'package:dandom/presentation/page/Main_page%20/LoginSignUppage/Loginpage.dart';
import 'package:dandom/presentation/page/MainNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Profile profile = Profile();
  final formkey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text(snapshot.error.toString())),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Register"),
              centerTitle: true,
              backgroundColor: Colors.green[300],
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                child: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("E-mail"),
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อนeE-mail"),
                            EmailValidator(errorText: "รูปแบบE-mailไม่ถูกต้อง"),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (String? email) {
                            profile.email = email;
                          },
                        ),
                        SizedBox(height: 30),
                        Text("Password"),
                        TextFormField(
                          validator: RequiredValidator(
                            errorText: "กรุณากรอกPassword",
                          ),
                          obscureText: true,
                          onSaved: (String? password) {
                            profile.password = password;
                          },
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text("Register"),
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                formkey.currentState!.save();

                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                        email: profile.email!,
                                        password: profile.password!,
                                      )
                                      .then((value) {
                                        formkey.currentState!.reset();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("สมัครสมาชิกสำเร็จ"),
                                          ),
                                        );
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginPage()));
                                      });
                                } on FirebaseAuthException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.message ?? "เกิดข้อผิดพลาด",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.home),
                            label: Text("Go Random"),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainNavigation(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("Error")),
          body: Center(child: Text("${snapshot.error}")),
        );
      },
    );
  }
}
