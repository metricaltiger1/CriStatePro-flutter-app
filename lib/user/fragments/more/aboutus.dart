import 'package:cristatepro/settings/feedback.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = Get.put(CurrentUser());

    String phoneNumber = '+254707390793';
    String message =
        'Hello, I am ${currentUser.user.userFirstName} ${currentUser.user.userLastName}, contacting you via CrisTatePro. ';
    String whatsappLink =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';
    String emailAddress = 'kokumuchris@gmail.com';
    String subject = 'Inquiry about CrisTatePro';
    String body =
        'Hello,\n\nI am ${currentUser.user.userFirstName} ${currentUser.user.userLastName}, reaching out regarding CrisTatePro...';
    String gmailLink =
        'mailto:$emailAddress?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "About Us",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to CrisTatePro!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Who We Are:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'CrisTatePro is a leading platform dedicated to revolutionizing the way people find rental properties. Our mission is to provide a seamless and enjoyable experience for users seeking their dream homes. We understand the importance of finding the perfect place to live, and CrisTatePro is here to make that process easier, efficient, and enjoyable.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Our Vision:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'At CrisTatePro, we envision a world where everyone can effortlessly discover their ideal rental property. We strive to be the go-to platform for individuals and families in search of a home that meets their unique preferences and requirements. Our commitment to innovation, user satisfaction, and community building sets us apart in the real estate industry.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'What Sets Us Apart:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '1. **Comprehensive Listings:** Explore a wide range of rental properties, including apartments, houses, condos, and more.\n2. **User-Friendly Interface:** Our intuitive design ensures a smooth and enjoyable experience for users of all backgrounds.\n3. **Interactive Map View:** Visualize property locations and explore neighborhoods with ease.\n4. **Save Favourites:** Save and compare your favourite properties to make informed decisions.\n5. **Search Alerts:** Receive notifications when new listings matching your criteria become available.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Connect With Us:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'We value the feedback and engagement of our users. Connect with us on social media, and feel free to reach out with any questions, suggestions, or concerns. Your satisfaction is our priority.',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => FeedbackPage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      'assets/forum.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    const instagramUrl =
                        'https://www.instagram.com/cristatepro/';
                    launchUrl(Uri.parse(instagramUrl));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      'assets/instagram.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(whatsappLink));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      'assets/whatsapp.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(gmailLink));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      'assets/gmail.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Thank you for choosing CrisTatePro!',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
