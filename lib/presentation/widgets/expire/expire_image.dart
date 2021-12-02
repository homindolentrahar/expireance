import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/presentation/widgets/core/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpireImage extends StatelessWidget {
  final File? imageFile;
  final VoidCallback capturePhoto;
  final VoidCallback pickImage;

  const ExpireImage({
    Key? key,
    required this.imageFile,
    required this.capturePhoto,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageFile == null
        ? InkWell(
            splashColor: AppColor.gray.withOpacity(0.2),
            highlightColor: AppColor.gray.withOpacity(0.25),
            onTap: () {
              Get.bottomSheet(
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTiles(
                        icon: SvgPicture.asset(
                          "assets/icons/camera.svg",
                          width: 24,
                          height: 24,
                          color: AppColor.dark,
                        ),
                        title: "Capture Photo",
                        onTap: capturePhoto,
                      ),
                      IconTiles(
                        icon: SvgPicture.asset(
                          "assets/icons/image.svg",
                          width: 24,
                          height: 24,
                          color: AppColor.dark,
                        ),
                        title: "Pick Image",
                        onTap: pickImage,
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              width: 104,
              height: 152,
              alignment: Alignment.center,
              decoration: DottedDecoration(
                color: AppColor.gray,
                borderRadius: BorderRadius.circular(2),
                shape: Shape.box,
              ),
              child: SvgPicture.asset(
                "assets/icons/image.svg",
                width: 32,
                height: 32,
                color: AppColor.gray,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.file(
              imageFile!,
              width: 104,
              height: 152,
              fit: BoxFit.cover,
            ),
          );
  }
}
