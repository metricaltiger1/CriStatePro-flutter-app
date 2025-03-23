import 'package:flutter/material.dart';
import 'package:cristatepro/widgets/star_rating.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/widgets/customtext.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HouseCardWidget extends StatelessWidget {
  final HouseModel house;
  final int index;

  const HouseCardWidget({super.key, required this.house, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isOddIndex = index % 2 == 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.9),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isOddIndex)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildHouseDetails(context),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: API.profilemage + house.houseProfileImage,
                placeholder: (context, url) => Center(
                  child: Lottie.asset(
                    'assets/progressbar.json',
                    width: 60,
                    height: 60,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            if (isOddIndex)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildHouseDetails(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label:
              '${house.houseTitle} ${_getTransactionTypeText(house.transactionType)}',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            if (int.parse(house.houseBedrooms) > 0)
              _buildIconWithText(Icons.bed, '${house.houseBedrooms} BR'),
            if (int.parse(house.houseBedrooms) > 0 &&
                int.parse(house.houseBathrooms) > 0)
              const SizedBox(width: 8),
            if (int.parse(house.houseBathrooms) > 0)
              _buildIconWithText(Icons.bathtub, '${house.houseBathrooms} BA'),
            StarRating(
              rating: house.averageRating.toDouble(),
              totalStars: 5,
              filledStar: Icons.star,
              unfilledStar: Icons.star_border,
              size: 10,
              interactive: false,
              halfFilledStar: Icons.star_half,
            ),
          ],
        ),
        CustomText(
          label: 'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
          fontSize: 16,
          lableColor: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 19,
            ),
            Expanded(
              child: Text(
                _getAddress(house.houseLocation),
                style: const TextStyle(fontSize: 18, color: Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _getTransactionTypeText(String transactionType) {
    switch (transactionType.toLowerCase()) {
      case 'office':
        return 'for Office Booking';
      case 'rent':
        return 'for Rent';
      case 'book':
        return 'for Air BnB services';
      default:
        return 'for Sale';
    }
  }

  String _getAddress(String locationString) {
    List<String> parts = locationString.split(', ');
    if (parts.length >= 4) {
      return '${parts[2]}, ${parts[3]}';
    } else {
      return '';
    }
  }
}
