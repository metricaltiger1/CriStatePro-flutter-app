import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Terms & Conditions",
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
              '1. Acceptance of Terms:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'By accessing or using CrisTatePro (the "App"), you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Use of the App:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'You must use the App in accordance with all applicable laws and regulations. Unauthorized use of the App may give rise to a claim for damages and/or be a criminal offense.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. User Accounts:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'To access certain features of the App, you may be required to create a user account. You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Intellectual Property:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The App and its original content, features, and functionality are owned by CrisTatePro and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Limitation of Liability:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'In no event shall CrisTatePro be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Governing Law:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These Terms and Conditions are governed by and construed in accordance with the laws of Kenya, and you submit to the non-exclusive jurisdiction of the state and federal courts located in Kenya for the resolution of any disputes.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Changes to Terms and Conditions:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right to modify or replace these Terms and Conditions at any time. Changes will be effective immediately upon posting. Your continued use of the App following the posting of any changes constitutes acceptance of those changes.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '8. User Conduct:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'You agree to use the App for lawful purposes and in a way that does not infringe on the rights of other users or third parties. Prohibited activities include but are not limited to: transmitting inappropriate content, attempting to gain unauthorized access, and engaging in any form of illegal activity.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '9. Termination:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right to terminate or suspend your account and access to the App at our sole discretion, without prior notice or liability, for any reason, including without limitation if you breach the Terms and Conditions.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '10. Contact Information:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions about these Terms and Conditions, please contact us at kokumuchris@gmail.com.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
