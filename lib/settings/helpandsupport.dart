import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Help & Support",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to CrisTatePro Support!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'If you have any questions, issues, or need assistance, please feel free to reach out to our support team. We are here to help you!',
              ),
              SizedBox(height: 16),
              SupportItem(
                title: 'Contact Support',
                description:
                    'For immediate assistance, you can contact our support team through the following email address:',
                contactInfo: 'support@christatepro.com',
              ),
              SizedBox(height: 16),
              SupportItem(
                title: 'FAQs (Frequently Asked Questions)',
                description:
                    'Check our FAQs for answers to common questions and troubleshooting tips:',
                contactInfo: 'www.christatepro.com/faqs',
              ),
              SizedBox(height: 16),
              SupportItem(
                title: 'User Guides',
                description:
                    'Explore our user guides for step-by-step instructions and tips on using CrisTatePro:',
                contactInfo: 'www.christatepro.com/user-guides',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportItem extends StatelessWidget {
  final String title;
  final String description;
  final String contactInfo;

  const SupportItem({
    super.key,
    required this.title,
    required this.description,
    required this.contactInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 4),
          Text(
            contactInfo,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
