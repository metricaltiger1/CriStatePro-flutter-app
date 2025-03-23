import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Privacy Policy",
          centerTitle: false,
        ),
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Effective Date: 23-March-2024',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Introduction:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Welcome to CrisTatePro (the "App"). Your privacy is important to us. This privacy policy is intended to inform you about the types of information we may collect, how we use that information, and the choices you have regarding your information.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Information We Collect:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may collect various types of information, including but not limited to:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
                '- Personal Information: Your name, email address, and other contact details.'),
            Text(
                '- Device Information: Information about your device, such as device type, operating system, and unique device identifiers.'),
            Text(
                '- Usage Information: Information about how you interact with the App, such as the features you use and the pages you visit.'),
            Text(
                '- Location Information: If you enable location services, we may collect information about your device\'s location.'),
            SizedBox(height: 16.0),
            Text(
              'How We Use Your Information:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We use the information we collect for various purposes, including:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text('- Providing and improving the App'),
            Text('- Personalizing your experience'),
            Text('- Sending important notifications and updates'),
            Text('- Analyzing usage patterns and improving our services'),
            SizedBox(height: 16.0),
            Text(
              'Information Sharing:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Choices:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'You have choices regarding the information you provide and how it is used:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text('- You can update your personal information within the App.'),
            Text(
                '- You may choose to disable location services on your device.'),
            Text(
                '- You can opt-out of certain communications by adjusting your preferences.'),
            SizedBox(height: 16.0),
            Text(
              'Security Measures:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We take reasonable measures to protect your information from unauthorized access or disclosure. However, no method of transmission over the internet or electronic storage is completely secure.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Changes to this Privacy Policy:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this privacy policy from time to time. Any changes will be posted on this page, and the effective date will be updated accordingly. We encourage you to review this policy periodically.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions about this privacy policy, please contact us at kokumuchris@gmail.com.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
