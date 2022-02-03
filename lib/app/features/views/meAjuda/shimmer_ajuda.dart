import 'package:flutter/material.dart';
import 'package:tabela_treino/app/shared/shimmer/skeleton.dart';

class ShimmerAjuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 12.0, 32.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(height: 30, width: width * 0.7),
          SizedBox(
            height: 8,
          ),
          Skeleton(height: 20, width: width * 0.8),
          Divider(
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}
