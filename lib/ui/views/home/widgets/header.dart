import 'package:flutter/material.dart';

class CelebrityGroupHeader extends StatelessWidget {
  final String title;

  const CelebrityGroupHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   style: TextButton.styleFrom(
          //     fixedSize: const Size(75, 36),
          //     minimumSize: const Size(75, 36),
          //   ),
          //   child: const Text(
          //     'See All',
          //     style: TextStyle(
          //       color: Color(0xFFFF8686),
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
