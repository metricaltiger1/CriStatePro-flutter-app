import 'package:cristatepro/admin/fragments/home/add_house_view.dart';
import 'package:cristatepro/admin/fragments/houses/admin_house_list_view.dart';
import 'package:cristatepro/user/controllers/subscription.dart';
import 'package:cristatepro/user/fragments/more/pricing.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPostingScreen extends StatelessWidget {
  const UserPostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = Get.put(CurrentUser());

    final SubscriptionController subscriptionController =
        Get.put(SubscriptionController());

    subscriptionController.fetchSubscriptionRemaining(currentUser.user.userId);
    RxInt remainingSubscription = subscriptionController.subscriptionRemaining;

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "New Post",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to CrisTatePro!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready to showcase your properties to potential clients? Let\'s get started by posting your properties!',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => Text(
                      'Remaining Subscription: $remainingSubscription',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (remainingSubscription < 1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Subscription Required'),
                              content: const Text(
                                'You need to subscribe to post more houses.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Get.off(() => const PricingPage());
                                  },
                                  child: const Text('Subscribe Now'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Get.to(() => AddHouseView());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Post Now',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => AdminHouseListView());
              },
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                "View your posted houses",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
