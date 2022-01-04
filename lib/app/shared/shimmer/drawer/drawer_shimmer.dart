import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';

import '../skeleton.dart';

class DrawerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        color: AppColors.grey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 42.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Skeleton(height: 100, width: 100)),
              ),
              SizedBox(
                height: 12,
              ),
              Skeleton(height: 30, width: width * 0.5),
              SizedBox(
                height: 12,
              ),
              Skeleton(height: 30, width: width * 0.4),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Skeleton(height: 40, width: width * 0.15),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Skeleton(height: 40, width: width * 0.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Skeleton(height: 40, width: width * 0.15),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Skeleton(height: 40, width: width * 0.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Skeleton(height: 40, width: width * 0.15),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Skeleton(height: 40, width: width * 0.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Skeleton(height: 40, width: width * 0.15),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Skeleton(height: 40, width: width * 0.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Skeleton(height: 40, width: width * 0.15),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Skeleton(height: 40, width: width * 0.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Shimmer.fromColors(
            child: DrawerLoading(),
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.grey300),
      ),
    );
  }
}
