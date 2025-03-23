import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/user/controllers/reset_password_controller.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final PasswordResetController controller = Get.put(PasswordResetController());

  ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: 'Reset Password',
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/reset.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.completionPercentage.value > 0 &&
                      controller.completionPercentage.value < 1.0)
                    Text(
                      'Hello ${controller.firstName} ${controller.lastName}, you are ${(controller.completionPercentage.value * 100).toInt()}% done.',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 2),
                  if (controller.completionPercentage.value >= 0.33)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Email verification',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              TextSpan(
                                text: '   ',
                              ),
                              TextSpan(
                                text: '✅',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (controller.completionPercentage.value >= 0.66)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Phone number completion ',
                            style: TextStyle(fontSize: 16)),
                        Text('✅', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  if (controller.completionPercentage.value >= 1.0)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('New password with confirmation ',
                            style: TextStyle(fontSize: 16)),
                        Text('✅', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (controller.completionPercentage.value < 0.33) ...[
                    const Text(
                      'Welcome back! If you’ve forgotten your password, don’t worry—we’re here to help you get back on track. Please enter your email address below, and we’ll assist you in resetting your password so you can regain access to your account. Your security is important to us, and we’re committed to making this process as smooth as possible!',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      ),
                      onPressed: controller.checkEmail,
                      label: const Text('Next'),
                    ),
                  ] else if (controller.completionPercentage.value < 0.66 &&
                      controller.isEmailChecked.value) ...[
                    Text(
                        'Hello ${controller.firstName} ${controller.lastName}, to proceed complete the number below'),
                    Text(controller.maskedPhone.value),
                    TextField(
                      controller: controller.phoneNumberController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: 'Complete phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.phoneNumberController.text.isEmpty) {
                          controller.showToast(
                              'Please complete your phone number.', false);
                        } else if (controller.checkPhoneNumberInput()) {
                          controller.completionPercentage.value = 0.66;
                        } else {
                          controller.showToast(
                              'Phone number does not match', false);
                        }
                      },
                      child: const Text('Next'),
                    ),
                  ] else if (controller.isEmailChecked.value &&
                      controller.completionPercentage.value < 1.0) ...[
                    TextField(
                      controller: controller.newPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: 'Enter New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white60),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            controller.isObscure.value =
                                !controller.isObscure.value;
                          },
                        ),
                      ),
                      obscureText: controller.isObscure.value,
                      onChanged: (value) => controller.newPassword.value = value,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller.confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: 'Confirm New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white60),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            controller.isObscure.value =
                                !controller.isObscure.value;
                          },
                        ),
                      ),
                      obscureText: controller.isObscure.value,
                      onChanged: (value) => controller.confirmPassword = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.resetPassword,
                      child: const Text('Reset Password'),
                    ),
                  ],
                  if (controller.completionPercentage.value == 1.0) ...[
                    Column(
                      children: [
                        Text(
                          'Awesome, ${controller.firstName}! 🎉 Your password has been successfully changed. You’re all set to dive back into your account! Just a moment—hold tight as we redirect you to the sign-in screen in the next ${controller.countdown.value} seconds. We can’t wait to see you back!',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Obx(() => Text(
                              'Redirecting in ${controller.countdown.value} seconds',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
