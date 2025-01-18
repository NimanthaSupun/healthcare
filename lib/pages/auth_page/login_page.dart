import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/services/auth/auth_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // todo: method to sing with email and password
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      GoRouter.of(context).go('/main-screen');
    } catch (error) {
      print(error.toString());

    if(context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("${error}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    }
   }
 }

  // todo: sing in with google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await AuthService().signInWithGoogle();
      GoRouter.of(context).go('/main-screen');
    } catch (error) {
      print(error.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("${error}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 150,
                      child: FadeInDown(
                        duration: const Duration(seconds: 1),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 100,
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      child: FadeInDown(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),

              // todo: background navigator is END
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Column(
                        children: [
                          CustomInput(
                            controller: _emailController,
                            labelText: "email",
                            icon: Icons.email,
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomInput(
                            controller: _passwordController,
                            labelText: "Password",
                            icon: Icons.lock,
                            obsecureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please enter your password";
                              }
                              if (value.length < 6) {
                                return "password must be at least 6 characters long";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      // todo:button
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: CustomButton(
                        title: "Log in",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () => _signInWithEmailAndPassword(context),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: Text(
                        "Sign in with Google to access the app's features",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: CustomButton(
                        title: "Sign in with Google",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () => _signInWithGoogle(context),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).go("/register");
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(
                            color: mainBlueColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
