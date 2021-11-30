import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_fonts.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/register/components/app_bar_register.dart';
import 'package:tabela_treino/app/features/views/register/components/gender_widget.dart';
import 'package:tabela_treino/app/features/views/register/components/login_button.dart';
import 'package:tabela_treino/app/features/views/register/components/personal_widget.dart';
import 'package:tabela_treino/app/features/views/register/components/text_form_field.dart';
import 'package:tabela_treino/app/shared/dialogs/custom_alert_dialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();

  final MaskTextInputFormatter celFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {'#': RegExp('[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscureTextPass = true;
  bool _obscureTextPassConf = true;
  bool _isEnable = true;

  int sexo = 0;
  bool isPersonal = false;

  User user = User();

  void changeObscurePass(bool obscureText) {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    showDialogMessage();
  }

  void showDialogMessage() async {
    await Future.delayed(const Duration(seconds: 1));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomAlertDialogs(
            title: Text(
              "Aviso!",
              style: TextStyle(
                color: AppColors.mainColor,
                fontFamily: AppFonts.gotham,
              ),
            ),
            content: Text(
              "Agora você somente pode adicionar sua foto de perfil após completar todo o cadastro!",
              style: TextStyle(
                height: 1.1,
                color: AppColors.mainColor,
                fontFamily: AppFonts.gothamBook,
              ),
            ),
            androidActions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                      color: AppColors.mainColor,
                      fontFamily: AppFonts.gothamBold,
                      fontSize: 20.0),
                ),
              ),
            ],
            iosActions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontFamily: AppFonts.gothamBold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(120), child: AppBarRegister()),
        backgroundColor: AppColors.grey,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: 12.0),
                      child: AutoSizeText(
                        AppTexts.registerWelcomeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.1,
                            fontSize: 18.0,
                            color: AppColors.mainColor,
                            fontFamily: AppFonts.gotham),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.4,
                              textController: _nameController,
                              textInputType: TextInputType.text,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              labelText: 'Nome',
                              enable: _isEnable,
                              validator: (text) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.4,
                              textController: _lastNameController,
                              enable: _isEnable,
                              textInputType: TextInputType.text,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              labelText: 'Sobrenome',
                              validator: (text) {},
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.8,
                              textController: _emailController,
                              enable: _isEnable,
                              textInputType: TextInputType.text,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              labelText: 'E-mail',
                              validator: (text) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.8,
                              textController: _numberController,
                              enable: _isEnable,
                              textInputType: TextInputType.number,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              labelText: 'Telefone',
                              inputFormatters: [
                                celFormatter,
                              ],
                              validator: (text) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.pin,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.8,
                              textController: _passController,
                              enable: _isEnable,
                              textInputType: TextInputType.text,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              isObscure: _obscureTextPass,
                              labelText: 'Senha',
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextPass = !_obscureTextPass;
                                    });
                                  },
                                  icon: Icon(_obscureTextPass
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (text) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.enhanced_encryption,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CustomTextFormField(
                              width: width * 0.8,
                              textController: _passConfirmController,
                              enable: _isEnable,
                              textInputType: TextInputType.text,
                              textColor: AppColors.mainColor,
                              labelColor: AppColors.mainColor,
                              isObscure: _obscureTextPass,
                              labelText: 'Confirmar Senha',
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextPassConf =
                                          !_obscureTextPassConf;
                                    });
                                  },
                                  icon: Icon(_obscureTextPassConf
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (text) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        height: 120,
                        child: Column(
                          children: [
                            Text("Gênero",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 25,
                                  fontFamily: AppFonts.gothamLight,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GenderContainer(
                                  label: "Masculino",
                                  sexo: sexo,
                                  type: 0,
                                  onTap: () {
                                    setState(() {
                                      sexo = 0;
                                    });
                                  },
                                ),
                                GenderContainer(
                                  label: "Feminino",
                                  sexo: sexo,
                                  type: 1,
                                  onTap: () {
                                    setState(() {
                                      sexo = 1;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      child: Column(
                        children: [
                          Text("Você é Personal Trainer?",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 25,
                                fontFamily: AppFonts.gothamLight,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PersonalContainer(
                                isPersonal: isPersonal,
                                label: 'Sim',
                                type: true,
                                onTap: () {
                                  setState(() {
                                    isPersonal = true;
                                  });
                                },
                              ),
                              PersonalContainer(
                                isPersonal: isPersonal,
                                label: 'Não',
                                type: false,
                                onTap: () {
                                  setState(() {
                                    isPersonal = false;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: LoginButton(
                        onTap: () async {
                          // SET USER
                          user = User(
                              name: _nameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              phoneNumber: celFormatter.getUnmaskedText(),
                              isPayApp: false,
                              isPersonal: isPersonal,
                              sex: sexo == 0 ? "Masculino" : "Feminino",
                              photoURL: AppTexts.photoURL);

                          setState(() {
                            _isEnable = false;
                          });
                          await userManager.singUp(
                              user, _passController.text, _onSucess, _onFailed);
                          setState(() {
                            _isEnable = true;
                          });
                        },
                        isLoading: userManager.loading,
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }

  void mostrarSnackBar(String message, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSucess() {
    mostrarSnackBar('Vamos lá!', Colors.green);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, (route) => false);
  }

  void _onFailed() {
    mostrarSnackBar(
        'Erro ao entrar, verifique seu email ou sua senha novamente',
        Colors.red);
  }
}
