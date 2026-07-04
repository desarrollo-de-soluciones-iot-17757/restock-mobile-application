import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class BusinessPictureField extends StatelessWidget {
  const BusinessPictureField({
    required this.pictureUrl,
    required this.image,
    required this.enabled,
    required this.onImageChanged,
    super.key,
  });

  final String pictureUrl;
  final XFile? image;
  final bool enabled;
  final ValueChanged<XFile?> onImageChanged;

  Future<void> _pickImage() async {
    if (!enabled) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onImageChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? _pickImage : null,
      child: Container(
        height: 142,
        width: double.infinity,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFF7F8FA) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? const Color(0xFFCDD2D9) : const Color(0xFFEEEEEE),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: _BusinessPictureContent(
          pictureUrl: pictureUrl,
          image: image,
          enabled: enabled,
        ),
      ),
    );
  }
}

class _BusinessPictureContent extends StatelessWidget {
  const _BusinessPictureContent({
    required this.pictureUrl,
    required this.image,
    required this.enabled,
  });

  final String pictureUrl;
  final XFile? image;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final selectedImage = image;
    if (selectedImage != null) {
      return Image.file(File(selectedImage.path), fit: BoxFit.cover);
    }

    if (pictureUrl.isNotEmpty) {
      return NetworkAwareImage(
        imageUrl: pictureUrl,
        fit: BoxFit.cover,
        placeholder: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: Color(0xFF9AA5B4),
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          color: enabled ? const Color(0xFF9AA5B4) : const Color(0xFFCCCCCC),
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          'BUSINESS IMAGE\nUPLOAD COVER PHOTO',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: enabled ? const Color(0xFF9AA5B4) : const Color(0xFFCCCCCC),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
