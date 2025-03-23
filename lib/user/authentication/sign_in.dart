import 'package:cristatepro/user/authentication/reset_password.dart';
import 'package:cristatepro/user/authentication/sign_up.dart';
import 'package:cristatepro/user/controllers/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  final SignInController _controller = Get.put(SignInController());

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sign_in.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, cons) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 280,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.all(
                              Radius.circular(60),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black45,
                                  offset: Offset(0, -3)),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                          child: Column(
                            children: [
                              Form(
                                key: _controller.formKey,
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.blue,
                                      backgroundImage:
                                          AssetImage('assets/user.png'),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "USER LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _controller.emailController,
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter email'
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        hintText: "Email Address",
                                        border: _controller.border,
                                        enabledBorder: _controller.border,
                                        focusedBorder: _controller.border,
                                        disabledBorder: _controller.border,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Obx(
                                      () => TextFormField(
                                        obscureText:
                                            _controller.isObscure.value,
                                        controller:
                                            _controller.passwordController,
                                        validator: (value) => value!.isEmpty
                                            ? 'Please enter password'
                                            : null,
                                        decoration: InputDecoration(
                                          suffixIcon: Obx(() => GestureDetector(
                                                onTap: () {
                                                  _controller.isObscure.value =
                                                      !_controller
                                                          .isObscure.value;
                                                },
                                                child: Icon(
                                                  _controller.isObscure.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black,
                                                ),
                                              )),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                          ),
                                          hintText: "Password",
                                          border: _controller.border,
                                          enabledBorder: _controller.border,
                                          focusedBorder: _controller.border,
                                          disabledBorder: _controller.border,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 6),
                                          fillColor: Colors.white,
                                          filled: true,
                                          errorStyle: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          if (_controller.formKey.currentState!
                                              .validate()) {
                                            _controller.signinUserNow(context);
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: Text(
                                            "Sign in",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => ForgetPasswordScreen());
                                        Get.delete<SignInController>();
                                      },
                                      child: const Text(
                                        "Reset",
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 16),
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => SignUpScreen());
                                        Get.delete<SignInController>();
                                      },
                                      child: const Text(
                                        "Sign up",
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 16),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
