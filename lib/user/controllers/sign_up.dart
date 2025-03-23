import 'dart:convert';

import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/authentication/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final isObscure = true.obs;
  final isLoading = false.obs;
  final userImage = Rx<XFile?>(null);
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.white60),
  );

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      userImage.value = pickedImage;
    }
  }

  void registerUser() async {
    if (_validateInputs()) {
      Get.dialog(
        AlertDialog(
          title: const Center(
            child: Text(
              'Registering...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      );

      isLoading.value = true;
      final Uri uri = Uri.parse(API.signUpUser);

      try {
        final request = http.MultipartRequest('POST', uri)
          ..fields['firstName'] = firstNameController.text
          ..fields['lastName'] = lastNameController.text
          ..fields['email'] = emailController.text
          ..fields['password'] = passwordController.text
          ..fields['phoneNumber'] = phoneController.text;

        if (userImage.value != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'user_profileImage',
            userImage.value!.path,
          ));
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          final Map<String, dynamic> data =
              json.decode(await response.stream.bytesToString());
          if (data['success']) {
            showToast('Registration successful', true);
            firstNameController.clear();
            lastNameController.clear();
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            phoneController.clear();
            userImage.value = null;
          } else {
            showToast('Registration failed: ${data['message']}', false);
          }
        } else {
          showToast('Error connecting to the server', false);
        }
      } catch (e) {
        showToast('Failed to sign up, check your internet connection.', false);
      } finally {
        isLoading.value = false;
        Get.back();
      }
    }
  }

  bool _validateInputs() {
    if (!Validators.isText(firstNameController.text.trim(), isRequired: true)) {
      showToast('Please enter a valid first name', false);
      return false;
    }

    if (!Validators.isText(lastNameController.text.trim(), isRequired: true)) {
      showToast('Please enter a valid last name', false);
      return false;
    }

    if (!Validators.isValidPhone(phoneController.text.trim(),
        isRequired: true)) {
      showToast('Please enter a valid phone number', false);
      return false;
    }
    if (!Validators.isValidEmail(emailController.text.trim(),
        isRequired: true)) {
      showToast('Please enter a valid email address', false);
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showToast('Please ensure passwords match', false);
      return false;
    }

    if (!Validators.isValidPassword(passwordController.text,
        isRequired: true)) {
      showToast(
          'Password should contain at least one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long',
          false);
      return false;
    }

    return true;
  }

  void showToast(String message, bool success) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
