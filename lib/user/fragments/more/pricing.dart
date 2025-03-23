import 'package:cristatepro/user/controllers/subscription.dart';
import 'package:cristatepro/user/fragments/more/post.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = Get.put(CurrentUser());
    String phoneNumber = '+254707390793';

    String message1 =
        'Hello, I am ${currentUser.user.userFirstName} ${currentUser.user.userLastName}, contacting you via CrisTatePro. I would like to subscribe for Standard Tier that goes for Ksh 500/- with the 5 listings for 60 days. Thank you.';
    String whatsappLink1 =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message1)}';

    String message2 =
        'Hello, I am ${currentUser.user.userFirstName} ${currentUser.user.userLastName}, contacting you via CrisTatePro. I would like to subscribe for Premium Tier that goes for Ksh 900/- with the 10 listings for 90 days. Thank you.';
    String whatsappLink2 =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message2)}';

    String message3 =
        'Hello, I am ${currentUser.user.userFirstName} ${currentUser.user.userLastName}, contacting you via CrisTatePro. I would like to subscribe for Enterprise Tier that goes for Ksh 5000/- with the unlimited listings for 30 days. Thank you.';
    String whatsappLink3 =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message3)}';

    final SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: 'CrisTatePro Pricing Plans',
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to CrisTatePro - Your Ultimate Solution for Finding the Perfect Rental Home!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'At CrisTatePro, we offer a range of pricing plans to suit your needs, whether you\'re an individual looking for a cozy apartment or a professional agent managing multiple properties. To redeem your free tier or to contact for paid tier, just click on the card to be redirected accordingly.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              PricingTierCard(
                title: 'Tier 1 (Basic)',
                description: 'Free Tier - 1 listing for 30 days',
                price: 'Free',
                details: const [
                  'Ideal for individuals or occasional users',
                  'List one property for free',
                  'Property remains active for 30 days',
                ],
                onTap: () {
                  subscriptionController.updateSubscription(
                      currentUser.user.userId, 1);
                },
              ),
              const SizedBox(height: 20),
              PricingTierCard(
                title: 'Tier 2 (Standard)',
                description: 'Paid Tier - 5 listings for 60 days',
                price: 'Ksh 500 Contact for subscription tokens',
                details: const [
                  'Perfect for regular users or small-scale property managers',
                  'List up to 5 properties',
                  'Each property remains active for 60 days',
                  'Access to standard listing features'
                ],
                onTap: () {
                  launchUrl(Uri.parse(whatsappLink1));
                },
              ),
              const SizedBox(height: 20),
              PricingTierCard(
                title: 'Tier 3 (Premium)',
                description: 'Paid Tier - 10 listings for 90 days',
                price: 'Ksh 900 Contact for subscription tokens',
                details: const [
                  'Great for professional agents or property management companies',
                  'List up to 10 properties',
                  'Each property remains active for 90 days',
                  'Access to premium listing features'
                ],
                onTap: () {
                  // _updateSubscription(currentUser.user.userId, 10);
                  launchUrl(Uri.parse(whatsappLink2));
                },
              ),
              const SizedBox(height: 20),
              PricingTierCard(
                title: 'Tier 4 (Enterprise)',
                description: 'Paid Tier - 100 listings for the next 90 days',
                price: 'Ksh 5000 Contact for subscription tokens',
                details: const [
                  'Best suited for large-scale property management operations',
                  '100 property listings',
                  'Each property remains active for 90 days',
                  'Full access to advanced listing features'
                ],
                onTap: () {
                  launchUrl(Uri.parse(whatsappLink3));
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Ready to start showcasing your properties to thousands of potential tenants/buyers? Choose the plan that best fits your needs and get started today!',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const UserPostingScreen());
                },
                child: const Text('Proceed to Posting Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PricingTierCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final List<String> details;
  final VoidCallback? onTap;

  const PricingTierCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: $price',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details
                    .map(
                      (detail) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                detail,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
