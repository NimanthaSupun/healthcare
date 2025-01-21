import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/users/user_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // final ImagePicker imagePicker = ImagePicker();
  // String _base64Image = "";
  // File? _imageFile;

  bool _isLoading = false;

  // // pick an image from
  // Future<void> _pickImage(ImageSource source) async {
  //   final XFile? image = await imagePicker.pickImage(source: source);

  //   if (image != null) {
  //     setState(
  //       () {
  //         _imageFile = File(image.path);
  //         _base64Image = base64Encode(_imageFile!.readAsBytesSync());
  //       },
  //     );
  //   }
  // }

  Future<void> _createUser(BuildContext context) async {
    try {
      // if (_imageFile != null) {
      //   final imageUrl = await UserProfileStorage().uploadImage(
      //     profileImage: _imageFile!,
      //     userEmail: _emailController.text,
      //   );
      // }

      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final UserModel newUser = UserModel(
        userId: "",
        name: _nameController.text,
        email: _emailController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        password: _passwordController.text,
        dateOfBirth: DateTime.now()
      );

      await UserService().saveUser(newUser);
      
      if (context.mounted) {
        UtilFunctions().showSnackBarWdget(
          context,
          "User Create Successfully",
        );
      }

      GoRouter.of(context).go('/main-screen');
    } catch (error) {
      print(error.toString());
      if (context.mounted) {
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
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
                            )),
                          )),
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

                    // Positioned(
                    //   child: FadeInDown(
                    //     duration: Duration(milliseconds: 1600),
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 50),
                    //       child: Center(
                    //         child: Stack(
                    //           children: [

                    //             _imageFile != null
                    //                 ? CircleAvatar(
                    //                     radius: 65,
                    //                     backgroundColor: mainBlueColor,
                    //                     backgroundImage: FileImage(_imageFile!),
                    //                   )
                    //                 : CircleAvatar(
                    //                     radius: 65,
                    //                     backgroundColor: mainBlueColor,
                    //                     backgroundImage: NetworkImage(
                    //                         "https://i.stack.imgur.com/l60Hf.png"),
                    //                   ),
                    //             Positioned(
                    //               bottom: -10,
                    //               left: 80,
                    //               child: IconButton(
                    //                 onPressed: () async {
                    //                   _pickImage(ImageSource.gallery);
                    //                 },
                    //                 icon: Icon(
                    //                   Icons.add_a_photo,
                    //                   color: Colors.black,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),

                    //   ),
                    // ),

                    Positioned(
                      child: FadeInDown(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: const Center(
                              child: Text(
                                "Register",
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
                            controller: _nameController,
                            labelText: "Name",
                            icon: Icons.person,
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                            height: 10,
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
                          SizedBox(
                            height: 10,
                          ),
                          CustomInput(
                            controller: _confirmPasswordController,
                            labelText: "confirm password",
                            icon: Icons.lock,
                            obsecureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please confirm your password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
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
                    _isLoading
                        ? CircularProgressIndicator()
                        : FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: CustomButton(
                              title: "Sign Up",
                              width: MediaQuery.of(context).size.width,
                              onPressed: () => _createUser(context),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).go("/login");
                        },
                        child: Text(
                          "Already have an account? Log in",
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
