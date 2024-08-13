import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

import 'components/app_bar_login.dart';
import 'components/text_form_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode passNode = FocusNode();
  bool _obscureTextPass = true;
  bool _isEnable = true;

  BannerAd? _bannerAd;

  @override
  void initState() {
    _initAdUnit();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _initAdUnit() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(
        keywords: [
          'GYM', 'WORKOUT', 'MUSCLE'
        ]
      ),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: PreferredSize(preferredSize: Size.fromHeight(130), child: AppBarLogin()),
          backgroundColor: Color(0xff313131),
          body: Form(
            key: _formKey,
            child: Column(
              //physics: BouncingScrollPhysics(),
              //padding: EdgeInsets.only(top: 40.0, left: 40, right: 40),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    child: LoginTextFormField(
                      width: width * 0.95,
                      textController: _emailController,
                      enable: _isEnable,
                      textInputType: TextInputType.text,
                      textColor: AppColors.white,
                      labelColor: AppColors.white,
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: AppColors.mainColor,
                      ),
                      onFieldSubmitted: (text) {
                        passNode.requestFocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                    child: LoginTextFormField(
                      width: width * 0.95,
                      textController: _passController,
                      enable: _isEnable,
                      textInputType: TextInputType.text,
                      textColor: AppColors.white,
                      labelColor: AppColors.white,
                      labelText: 'Senha',
                      isObscure: _obscureTextPass,
                      focusNode: passNode,
                      onFieldSubmitted: (text) async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isEnable = false;
                          });

                          final response = await userManager.signIn(_emailController.text.trim(), _passController.text);
                          if (response != null) {
                            _onFailed(response);
                            setState(() {
                              _isEnable = true;
                            });
                          } else {
                            _onSucess();
                          }
                        }
                      },
                      prefixIcon: Icon(
                        Icons.password_rounded,
                        color: AppColors.mainColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureTextPass = !_obscureTextPass;
                          });
                        },
                        icon: Icon(
                          _obscureTextPass ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isEnable = false;
                      });

                      final response = await userManager.signIn(_emailController.text.trim(), _passController.text);
                      if (response != null) {
                        _onFailed(response);
                        setState(() {
                          _isEnable = true;
                        });
                      } else {
                        _onSucess();
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 350),
                    curve: Curves.ease,
                    width: width * 0.95,
                    height: 60,
                    child: Center(
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              color: AppColors.grey,
                            )
                          : Text(
                              "Entrar",
                              style: TextStyle(fontFamily: AppFonts.gothamBold, fontSize: 30),
                            ),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 2, offset: Offset(0, 4))]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Esqueceu sua senha?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.white, fontFamily: AppFonts.gotham),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (_emailController.text.isEmpty) {
                                mostrarSnackBar(context: context, message: 'Insira seu e-mail para recuperação!', color: Colors.redAccent);
                              } else if (_emailController.text.isNotEmpty || _emailController.text.contains("@")) {
                                final response = await userManager.resetPassword(_emailController.text);
                                if (response != null) {
                                  mostrarSnackBar(context: context, message: 'Ocorreu um erro. Tente novamente mais tarde.', color: AppColors.red);
                                } else {
                                  mostrarSnackBar(context: context, message: 'Confira sua caixa de entrada em seu e-mail.', color: AppColors.lightGrey);
                                }
                              }
                            },
                            child: Text(
                              "Recupere aqui",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gothamBold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.only(bottom: 12.0, right: 10, left: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "Ainda não possui uma conta?",
                              maxLines: 1,
                              style: TextStyle(color: AppColors.white, fontFamily: AppFonts.gotham, fontSize: 12),
                            ),
                            const SizedBox(width: 12.0),
                            AutoSizeText(
                              "Criar Conta",
                              maxLines: 1,
                              style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gotham, fontSize: 16, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_bannerAd != null) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AdWidget(
                      ad: _bannerAd!,
                    ),
                  ),
                  const SizedBox(height: 24.0)
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSucess() {
    // await context.read<AdsManager>().resetAdsPreferences();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.tabs, (route) => false);
  }

  void _onFailed(String error) {
    mostrarSnackBar(context: context, message: error, color: AppColors.red);
  }
}
