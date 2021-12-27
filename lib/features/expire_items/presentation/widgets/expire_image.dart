import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpireImage extends StatelessWidget {
  final File? imageFile;
  final VoidCallback capturePhoto;
  final VoidCallback pickImage;
  final VoidCallback? removeImage;

  const ExpireImage({
    Key? key,
    required this.imageFile,
    required this.capturePhoto,
    required this.pickImage,
    this.removeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageFile == null
        ? InkWell(
            splashColor: AppColor.gray.withOpacity(0.2),
            highlightColor: AppColor.gray.withOpacity(0.25),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => _ImageSheet(
                  showRemove: imageFile != null,
                  capturePhoto: capturePhoto,
                  pickImage: pickImage,
                  removeImage: removeImage,
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
        : GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => _ImageSheet(
                  showRemove: imageFile != null,
                  capturePhoto: capturePhoto,
                  pickImage: pickImage,
                  removeImage: removeImage,
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.file(
                imageFile!,
                width: 104,
                height: 152,
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}

class _ImageSheet extends StatelessWidget {
  final bool showRemove;
  final VoidCallback capturePhoto;
  final VoidCallback pickImage;
  final VoidCallback? removeImage;

  const _ImageSheet({
    Key? key,
    required this.showRemove,
    required this.capturePhoto,
    required this.pickImage,
    required this.removeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          showRemove
              ? IconTiles(
                  icon: SvgPicture.asset(
                    "assets/icons/delete-fill.svg",
                    width: 24,
                    height: 24,
                    color: AppColor.red,
                  ),
                  title: "Remove Image",
                  textStyle: const TextStyle(
                    color: AppColor.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: removeImage ?? () {},
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
