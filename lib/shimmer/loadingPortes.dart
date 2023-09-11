import 'package:bv/shimmer/shimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Patientez extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return buildFoodShimmer(context);
      },
    );
  }

  Widget buildFoodShimmer(BuildContext context) => ListTile(
    leading: shimmerWidget.circular(width: 64, height: 64),
    title: Align(
        alignment: Alignment.centerLeft,
        child: shimmerWidget.reactangular(
          height: 16,
          width: MediaQuery.of(context).size.width * .3,)),
    subtitle: shimmerWidget.reactangular(height: 14),
  );
}
