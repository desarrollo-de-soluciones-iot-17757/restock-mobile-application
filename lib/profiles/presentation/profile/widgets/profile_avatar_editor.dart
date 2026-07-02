import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class ProfileAvatarEditor extends StatelessWidget {
  const ProfileAvatarEditor({
    required this.avatarUrl,
    required this.image,
    required this.onImageChanged,
    required this.enabled,
    super.key,
  });

  final String avatarUrl;
  final XFile? image;
  final ValueChanged<XFile?> onImageChanged;
  final bool enabled;

  Future<void> _pickImage() async {
    if (!enabled) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onImageChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 116,
          height: 116,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Color(0xFFDDE1E7),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: _AvatarImage(avatarUrl: avatarUrl, image: image),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 46,
          width: 168,
          child: OutlinedButton(
            onPressed: enabled ? _pickImage : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1F2026),
              side: const BorderSide(color: Color(0xFF74777F), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'UPLOAD NEW',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: enabled && image != null
              ? () => onImageChanged(null)
              : null,
          child: const Text(
            'REMOVE',
            style: TextStyle(
              color: Color(0xFFD32F2F),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.avatarUrl, required this.image});

  final String avatarUrl;
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    final selectedImage = image;
    if (selectedImage != null) {
      return Image.file(File(selectedImage.path), fit: BoxFit.cover);
    }

    return NetworkAwareImage(
      imageUrl: avatarUrl,
      fit: BoxFit.cover,
      placeholder: const ColoredBox(
        color: Color(0xFFEFF3F6),
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF8B95A1),
            size: 54,
          ),
        ),
      ),
    );
  }
}
