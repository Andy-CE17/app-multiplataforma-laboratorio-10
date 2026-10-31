import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.radius, this.imageBytes, super.key});

  final double radius;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object> image = imageBytes == null
        ? const AssetImage('assets/images/piero_avatar.png')
        : MemoryImage(imageBytes!);

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF0D1A31),
      backgroundImage: image,
    );
  }
}
