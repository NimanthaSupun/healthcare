import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/users/user_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserModel user;
  const UpdateProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  // late TextEditingController _emailController = TextEditingController();

  DateTime selectedDate = DateTime(2003, 5, 9);
  String selectedSex = 'Male';
  int selectedFeet = 5;
  int selectedInches = 6;
  int selectedWeight = 128;
  String selectedBloodGroup = 'A+'; // Added blood group

  // List of blood groups
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  final ImagePicker imagePicker = ImagePicker();
  // XFile? _selectedImage;
  String? _base64Image;
  File? _image;

  Future<void> _pickedImage(ImageSource gallery) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      // _selectedImage = image;
      _image = File(image!.path);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    selectedSex = widget.user.sex!;
    selectedFeet = widget.user.heightFeet as int;
    selectedInches = widget.user.heightInches as int;
    selectedWeight = widget.user.weight as int;
    selectedBloodGroup = widget.user.bloodGroup!;
    _base64Image = widget.user.imageUrl;
  }

  bool _isLoading = false;

  void _updateUser(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final UserModel updateUser = UserModel(
        userId: widget.user.userId,
        name: _nameController.text,
        email: widget.user.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        password: widget.user.password,
        dateOfBirth: selectedDate,
        bloodGroup: selectedBloodGroup,
        heightFeet: selectedFeet,
        heightInches: selectedInches,
        imageUrl: _base64Image,
        sex: selectedSex,
        weight: selectedWeight,
      );

      await UserService().updateUser(
        widget.user.userId,
        updateUser,
      );

      if (context.mounted) {
        UtilFunctions().showSnackBarWdget(
          context,
          "User Update Successfully",
        );
      }
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    } catch (error) {
      print("Error: ${error}");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Center(
                      child: Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 65,
                                  backgroundColor: mainBlueColor,
                                  backgroundImage: FileImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 65,
                                  backgroundColor: mainBlueColor,
                                  backgroundImage: NetworkImage(
                                    "https://i.stack.imgur.com/l60Hf.png",
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () async {
                                _pickedImage(ImageSource.gallery);
                              },
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                    height: 25,
                  ),
                  _buildInfoRow(
                    'Date of Birth',
                    '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                    onTap: _showDatePicker,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    'Sex',
                    selectedSex,
                    onTap: _showSexPicker,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    'Height',
                    "$selectedFeet' $selectedInches\"",
                    onTap: _showHeightPicker,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    'Weight',
                    '$selectedWeight lb',
                    onTap: _showWeightPicker,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    'Blood Group',
                    selectedBloodGroup,
                    onTap: _showBloodGroupPicker,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          title: "Done",
                          width: double.infinity,
                          onPressed: () => _updateUser(context),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider();
  }

  void _showBloodGroupPicker() {
    _showPicker(
      CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) {
          setState(() => selectedBloodGroup = bloodGroups[index]);
        },
        children: bloodGroups.map((String value) {
          return Text(value,
              style: TextStyle(color: Colors.black, fontSize: 20));
        }).toList(),
      ),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: selectedDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => selectedDate = newDate);
            },
          ),
        ),
      ),
    );
  }

  void _showSexPicker() {
    final List<String> sexOptions = ['Not Set', 'Female', 'Male', 'Other'];
    _showPicker(
      CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) {
          setState(() => selectedSex = sexOptions[index]);
        },
        children: sexOptions.map((String value) {
          return Text(value);
        }).toList(),
      ),
    );
  }

  void _showHeightPicker() {
    _showPicker(
      Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() => selectedFeet = index + 2);
              },
              children: List<Widget>.generate(7, (index) {
                return Text('${index + 2} ft');
              }),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() => selectedInches = index);
              },
              children: List<Widget>.generate(12, (index) {
                return Text('$index in');
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showWeightPicker() {
    _showPicker(
      CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) {
          setState(() => selectedWeight = index + 50);
        },
        children: List<Widget>.generate(251, (index) {
          return Text('${index + 50} lb');
        }),
      ),
    );
  }

  void _showPicker(Widget picker) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
