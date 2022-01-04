import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key key, @required this.height, @required this.width})
      : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AppColors.lightGrey, borderRadius: BorderRadius.circular(8)),
    );
  }
}
