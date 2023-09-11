import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, i){
          return Card(
            elevation: 5.0,
            shape: Border(),
            child: Container(
              height: 300,
            ),
          );
      }),
      baseColor: Colors.grey.shade300,
      highlightColor: Theme.of(context).primaryColorLight
  );
}
