import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.imageUrl, this.image, this.onTap, super.key});

  final String? imageUrl;
  final XFile? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final selectedImage = image;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF2A3550),
        child: ClipOval(
          child: selectedImage != null
              ? Image.file(
                  File(selectedImage.path),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )
              : NetworkAwareImage(
                  imageUrl: imageUrl ?? '',
                  width: 40,
                  height: 40,
                  placeholder: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF8899AA),
                    size: 22,
                  ),
                ),
        ),
      ),
    );
  }
}
