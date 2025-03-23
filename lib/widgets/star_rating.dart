import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/user/controllers/rating_controller.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int totalStars;
  final IconData filledStar;
  final IconData halfFilledStar;
  final IconData unfilledStar;
  final double size;
  final bool interactive;

  const StarRating({
    super.key,
    required this.rating,
    required this.totalStars,
    required this.filledStar,
    required this.halfFilledStar,
    required this.unfilledStar,
    required this.size,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    final RatingController ratingController = Get.put(RatingController());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        double fillValue = index + 1;

        IconData iconData;
        if (fillValue <= rating) {
          iconData = filledStar;
        } else if (fillValue - rating < 0.9) {
          iconData = halfFilledStar;
        } else {
          iconData = unfilledStar;
        }

        return SizedBox(
          width: size,
          child: IconButton(
            onPressed: interactive
                ? () {
                    ratingController.setUserRating(fillValue);
                  }
                : null,
            icon: Icon(
              iconData,
              size: size,
              color: Colors.amber,
            ),
          ),
        );
      }),
    );
  }
}
