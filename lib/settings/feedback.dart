import 'package:cristatepro/admin/controllers/feedback_controller.dart';
import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  final FeedbackController _feedbackController = Get.put(FeedbackController());

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Provide Feedback",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SimpleBuilder(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We value your feedback!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please share your thoughts, suggestions, or any issues you encountered while using CrisTatePro. Your feedback helps us improve and provide a better experience for you.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _feedbackController.feedbackTextController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Enter your feedback here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _submitFeedback(context);
                  },
                  child: const Text('Submit Feedback'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submitFeedback(BuildContext context) async {
    if (_feedbackController.feedbackTextController.text.isEmpty) {
      showToast('Please enter your feedback.');

      return;
    }

    await _feedbackController
        .submitFeedback(_feedbackController.feedbackTextController.text);
  }

  void showToast(
    String message,
  ) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
    );
  }
}
