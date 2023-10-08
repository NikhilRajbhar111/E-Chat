import 'package:flutter/material.dart';
import 'package:my_app/services/auth/auth_service.dart';
import '../components/my_Button.dart';
import '../components/my_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password do not match")));
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //loop
                const Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.black,
                ),

                const SizedBox(height: 50),
                //welcome back msg
                const Text(
                  "Let's create an account for you!",
                  style: TextStyle(fontSize: 16),
                ),

                //email
                const SizedBox(height: 50),
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false),

                const SizedBox(height: 10),
                //passwrod
                MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true),
                //confirm password
                const SizedBox(height: 10),
                //passwrod
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm passwrod",
                    obscureText: true),

                const SizedBox(height: 25),
                //sign in button
                MyButton(onTap: signUp, text: 'Sign Up'),

                const SizedBox(height: 25),
                //not a member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already a member?",
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
