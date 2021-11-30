import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class HomeLoadingScreen extends StatefulWidget {
  @override
  _HomeLoadingScreenState createState() => _HomeLoadingScreenState();
}

class _HomeLoadingScreenState extends State<HomeLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: width,
        color: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              height: 180,
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[850]),
            )
          ],
        ),
      ),
    );
  }
}
