import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class PreferenciasCard extends StatelessWidget {
  final Widget child;

  const PreferenciasCard({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
          color: AppColors.grey340, borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}
