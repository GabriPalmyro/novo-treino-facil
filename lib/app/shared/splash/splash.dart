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
    if (_auth.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.tabs, (route) => false);
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 150,
                  width: constraints.maxWidth * 0.45,
                  child: Image.asset(
                    AppImages.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Carregando Informações',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamLight,
                          fontSize: 18.0,
                          color: AppColors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.2,
                        color: AppColors.grey,
                        backgroundColor: AppColors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        })
      ],
    ));
  }
}
