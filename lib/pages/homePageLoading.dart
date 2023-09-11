import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Theme.of(context).primaryColorLight,
        child:GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, i){
              return Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.all(15),
                  width: 100.0,
                  height: 100.0,
                ),
              );
            }
        ),
    );
  }
}
