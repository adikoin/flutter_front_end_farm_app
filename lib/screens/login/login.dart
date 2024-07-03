import 'package:flutter/material.dart';
import 'package:vulpes/constant.dart';
import 'package:vulpes/screens/main/main_screen.dart';
import 'package:vulpes/util/user_operations.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';

final WebAppInitData webAppInitData = tg.initDataUnsafe;

final HttpService httpService = HttpService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  // int id = 784937345;
  int id = webAppInitData.user?.id as int;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Become Early Adopter",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                    controller: _emailController,
                    // keyboardType: TextInputType.number,
                    // inputFormatters: [maskFormatter],
                    decoration: const InputDecoration(labelText: 'Email'),
                    style: const TextStyle(
                      fontSize: 18.0,
                      height: 2.0,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your E-mail';
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter valid E-mail';
                      }
                      return null;
                    }),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1,
                        vertical: defaultPadding / 1),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      var updateEmail = await httpService.updateUserEmail(
                          id, _emailController.text);
                      if (!context.mounted) return;
                      if (updateEmail) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      } else {
                        _showError(context);
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Become early Adopter",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_showError(BuildContext context) {
  const snackBar = SnackBar(
    content: Text('Error, please try again later'),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 5),
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
