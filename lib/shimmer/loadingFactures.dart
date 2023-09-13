import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingFactures extends StatelessWidget {
  const LoadingFactures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, i){
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 5.0,
                shape: Border(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: 340,
                ),
              ),
            );
          }),
      baseColor: Colors.grey.shade300,
      highlightColor: Theme.of(context).primaryColorLight
  );
}
