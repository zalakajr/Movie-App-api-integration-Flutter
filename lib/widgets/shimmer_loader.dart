import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader(
      {super.key,
      required this.width,
      required this.height,
      required this.isCircular});

  final double width;
  final double height;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 20, 20, 20),
      highlightColor: const Color.fromARGB(255, 48, 48, 48),
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(204, 20, 20, 20),
          // circular if true
          borderRadius: isCircular ? null : BorderRadius.circular(10),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle
        ),
      ),
    );
  }
}
