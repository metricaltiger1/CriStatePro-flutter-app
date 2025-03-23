import 'dart:io';

import 'package:cristatepro/user/authentication/sign_in.dart';
import 'package:cristatepro/user/controllers/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController _controller = Get.put(SignUpController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sign_up.jpg'),
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
                    const SizedBox(
                      width: double.infinity,
                      height: 170,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                          child: Column(
                            children: [
                              Obx(
                                () => Center(
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            _controller.userImage.value != null
                                                ? FileImage(File(_controller
                                                    .userImage.value!.path))
                                                : const AssetImage(
                                                        'assets/user.png')
                                                    as ImageProvider,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.camera_alt),
                                            color: Colors.white,
                                            onPressed: _controller.selectImage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Form(
                                key: _controller.formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          _controller.firstNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        hintText: "First Name",
                                        border: _controller.border,
                                        enabledBorder: _controller.border,
                                        focusedBorder: _controller.border,
                                        disabledBorder: _controller.border,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller:
                                          _controller.lastNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        hintText: "Last Name",
                                        border: _controller.border,
                                        enabledBorder: _controller.border,
                                        focusedBorder: _controller.border,
                                        disabledBorder: _controller.border,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _controller.phoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.phone,
                                          color: Colors.black,
                                        ),
                                        hintText: "Phone Number",
                                        border: _controller.border,
                                        enabledBorder: _controller.border,
                                        focusedBorder: _controller.border,
                                        disabledBorder: _controller.border,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _controller.emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
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
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
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
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: Obx(
                                            () => GestureDetector(
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
                                            ),
                                          ),
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
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          errorStyle: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Obx(
                                      () => TextFormField(
                                        obscureText:
                                            _controller.isObscure.value,
                                        controller: _controller
                                            .confirmPasswordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: Obx(
                                            () => GestureDetector(
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
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                          ),
                                          hintText: "Confirm Password",
                                          border: _controller.border,
                                          enabledBorder: _controller.border,
                                          focusedBorder: _controller.border,
                                          disabledBorder: _controller.border,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          errorStyle: const TextStyle(
                                            fontSize: 16,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
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
                                            _controller.registerUser();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
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
                                    "Already have an account?",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.offAll(() => SignInScreen());
                                      Get.delete<SignUpController>();
                                    },
                                    child: const Text(
                                      "Sign in",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                  )
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
