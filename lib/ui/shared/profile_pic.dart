import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String? url;
  final double size;

  const ProfilePic({
    Key? key,
    required this.url,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: url == null
          ? const AssetImage('assets/profile-default.jpg')
          : CachedNetworkImageProvider(url!) as ImageProvider,
    );
  }
}

class ProfilePicSquare extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double width;
  final double height;

  const ProfilePicSquare({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: url == null
          ? const AssetImage('assets/profile-default.jpg')
          : CachedNetworkImageProvider(url!) as ImageProvider,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
