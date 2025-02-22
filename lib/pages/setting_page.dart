import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/provider/theme_provider.dart';
import 'package:healthcare/services/auth/auth_service.dart';
import 'package:healthcare/widgets/profile_widget/dark_light_card.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void _toggle() {
    Provider.of<ThemeProvide>(context, listen: false).toggleTheme(
      Theme.of(context).brightness != Brightness.dark,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingPage()),
    );
  }

  void singOut(BuildContext context) async {
    await AuthService().signOut();
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go('/login');
    // ignore: use_build_context_synchronously
    UtilFunctions().showSnackBarWdget(context, "sign out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Card(
                    child: ListTile(
                      title: Theme.of(context).brightness == Brightness.light
                          ? Text(
                              "Dark Mode",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Light Mode",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      trailing: GestureDetector(
                        onTap: _toggle,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: Theme.of(context).brightness == Brightness.dark
                              ? 50
                              : 100,
                          height:
                              Theme.of(context).brightness == Brightness.dark
                                  ? 50
                                  : 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                Theme.of(context).brightness == Brightness.dark
                                    ? BorderRadius.circular(100)
                                    : BorderRadius.circular(10),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.transparent,
                          ),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Theme.of(context).brightness == Brightness.dark
                                ? Icons.lightbulb
                                : Icons.dark_mode_rounded,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DarkLightCard(
                  title: "",
                  imageUrl: "",
                ),
                SizedBox(
                  height: 300,
                ),
                CustomButton(
                  title: "Log out",
                  width: double.infinity,
                  onPressed: () => singOut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
