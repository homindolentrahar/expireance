import 'package:carousel_slider/carousel_slider.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/presentation/widgets/expire/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpireItemCarousel extends StatefulWidget {
  final List<ExpireItemModel> models;

  const ExpireItemCarousel({
    Key? key,
    required this.models,
  }) : super(key: key);

  @override
  State<ExpireItemCarousel> createState() => _ExpireItemCarouselState();
}

class _ExpireItemCarouselState extends State<ExpireItemCarousel> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
              autoPlay: false,
              scrollDirection: Axis.horizontal,
              height: 80,
              pageSnapping: true,
              viewportFraction: 1,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              onPageChanged: (index, reason) {
                setState(() {
                  _activeIndex = index;
                });
              }),
          itemCount: widget.models.length,
          itemBuilder: (ctx, index, pageViewIndex) {
            return ExpireItemList(model: widget.models[index]);
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.models
              .asMap()
              .entries
              .map(
                (entry) => _Indicator(isActive: _activeIndex == entry.key),
              )
              .toList(),
        )
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isActive;

  const _Indicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutSine,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Get.theme.primaryColor : AppColor.gray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
