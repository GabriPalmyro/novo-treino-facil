import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';

import '../skeleton.dart';

class ExerciciosPlanilhaList extends StatefulWidget {
  @override
  _HomeLoadingScreenState createState() => _HomeLoadingScreenState();
}

class _HomeLoadingScreenState extends State<ExerciciosPlanilhaList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(
              height: 120,
              width: width,
            ),
            SizedBox(
              height: 12,
            ),
            Skeleton(
              height: 120,
              width: width,
            ),
            SizedBox(
              height: 12,
            ),
            Skeleton(
              height: 120,
              width: width,
            ),
            SizedBox(
              height: 12,
            ),
            Skeleton(
              height: 120,
              width: width,
            ),
            SizedBox(
              height: 12,
            ),
            Skeleton(
              height: 120,
              width: width,
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciciosPlanilhaShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
          child: ExerciciosPlanilhaList(),
          baseColor: AppColors.lightGrey,
          highlightColor: AppColors.lightGrey.withOpacity(0.6)),
    );
  }
}
