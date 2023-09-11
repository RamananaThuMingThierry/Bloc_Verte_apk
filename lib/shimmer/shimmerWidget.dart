import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class shimmerWidget extends StatelessWidget {

  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const shimmerWidget.reactangular({
    this.width = double.infinity,
    required this.height
  }) : this.shapeBorder = const RoundedRectangleBorder();


  const shimmerWidget.circular({
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Theme.of(context).primaryColorLight,
    child: Container(
      width: width,
      height: height,
      color: Colors.grey,
    ),
  );
}
