import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _hasLogin();
  }

  Future<void> _hasLogin() async {
    await context.read<CoreAppController>().getAppCore();
    await Future.delayed(Duration(seconds: 1));
    if (_auth.currentUser == null) {
      Navigator.pushNamed(context, AppRoutes.login);
    } else {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: AppColors.mainColor),
        ),
        LayoutBuilder(builder: (_, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Image.asset(
                AppImages.logo,
                fit: BoxFit.cover,
              ),
            ),
          );
        })
      ],
    ));
  }
}
