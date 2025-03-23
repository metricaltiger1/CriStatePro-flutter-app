import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "About App",
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
                'App Name: CrisTatePro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Introduction:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to CrisTatePro – your ultimate solution for finding the perfect rental home! CrisTatePro is a user-friendly mobile application designed to simplify the process of searching for rental properties. Whether you\'re a student looking for a cozy apartment, a family in need of a spacious house, or a young professional seeking a modern condo, CrisTatePro has got you covered.',
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              FeatureItem(
                title: 'User-friendly Interface',
                description:
                    'CrisTatePro boasts an intuitive and visually appealing interface, making it easy for users to navigate and search for their ideal rental property.',
              ),
              FeatureItem(
                title: 'Comprehensive Property Listings',
                description:
                    'Explore a vast database of rental properties, including apartments, houses, condos, and more. Filter listings based on location, price range, number of bedrooms, amenities, and other criteria to find homes that match your preferences.',
              ),
              FeatureItem(
                title: 'Detailed Property Profiles',
                description:
                    'Each property listing provides detailed information, including property photos, descriptions, amenities, rental terms, and contact information for the landlord or property manager.',
              ),
              FeatureItem(
                title: 'Interactive Map View',
                description:
                    'Visualize property locations on an interactive map, allowing users to explore neighborhoods and view nearby amenities such as schools, parks, restaurants, and public transportation.',
              ),
              FeatureItem(
                title: 'Save Favourites',
                description:
                    'Save your favourite properties to easily access them later and compare options before making a decision.',
              ),
              FeatureItem(
                title: 'Search Alerts',
                description:
                    'Set up search alerts to receive notifications when new rental properties that match your criteria become available, ensuring you never miss out on the perfect home.',
              ),
              FeatureItem(
                title: 'Contact Landlords',
                description:
                    'Easily contact landlords or property managers directly through the app to schedule viewings, ask questions, or submit rental applications.',
              ),
              FeatureItem(
                title: 'User Profiles',
                description:
                    'Create a personalized user profile to save your preferences, manage your saved listings, and track your search history.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.title,
    required this.description,
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
        ],
      ),
    );
  }
}
