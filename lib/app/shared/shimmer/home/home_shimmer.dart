import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';

import '../skeleton.dart';

class HomeLoadingScreen extends StatefulWidget {
  @override
  _HomeLoadingScreenState createState() => _HomeLoadingScreenState();
}

class _HomeLoadingScreenState extends State<HomeLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 24.0),
            child: Skeleton(
              height: 50,
              width: width * 0.5,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
            ),
            child: Skeleton(
              height: 40,
              width: width * 0.75,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
            ),
            child: Skeleton(
              height: 40,
              width: width * 0.65,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 6.0,
            ),
            child: Row(
              children: List.generate(
                  2,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Skeleton(height: 80, width: width * 0.3),
                      )),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Skeleton(
                  height: 80,
                  width: width,
                ),
                SizedBox(
                  height: 12,
                ),
                Skeleton(
                  height: 80,
                  width: width,
                ),
                SizedBox(
                  height: 12,
                ),
                Skeleton(
                  height: 80,
                  width: width,
                ),
                SizedBox(
                  height: 12,
                ),
                Skeleton(
                  height: 80,
                  width: width,
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomeLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
          child: HomeLoadingScreen(),
          baseColor: AppColors.lightGrey,
          highlightColor: AppColors.lightGrey.withOpacity(0.6)),
    );
  }
}
