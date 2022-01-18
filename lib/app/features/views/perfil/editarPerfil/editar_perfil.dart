import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/register/components/text_form_field.dart';
import 'package:tabela_treino/app/helpers/email_valid.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';

class EditarPerfilScreen extends StatefulWidget {
  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  //* CONTROLLERS
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _passController = TextEditingController();
  final _nicknameController = TextEditingController();

  final MaskTextInputFormatter celFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {'#': RegExp('[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isEnable = true;
  bool _obscureTextPass = true;

  int sexo = 0;
  bool isPersonal = false;

  @override
  void initState() {
    super.initState();
    getUserInfos();
  }

  getUserInfos() {
    setState(() {
      _nicknameController.text = context.read<UserManager>().user.nickname;
      _nameController.text = context.read<UserManager>().user.name;
      _lastNameController.text = context.read<UserManager>().user.lastName;
      _lastNameController.text = context.read<UserManager>().user.lastName;
      _emailController.text = context.read<UserManager>().user.email;
      _numberController.text =
          celFormatter.maskText(context.read<UserManager>().user.phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey[850],
          elevation: 25,
          centerTitle: true,
          title: Text(
            "Editar Perfil",
            style: TextStyle(
                color: Colors.grey[850],
                fontFamily: AppFonts.gothamBold,
                fontSize: 25),
          ),
          backgroundColor: AppColors.mainColor,
        ),
        backgroundColor: const Color(0xff313131),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 24.0, 10.0, 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_nameController.text.isEmpty)
                                      return 'Nome não pode ser vazio';
                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.4,
                                      textController: _nameController,
                                      textInputType: TextInputType.text,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelText: 'Nome',
                                      enable: _isEnable,
                                      validator: (text) {},
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_lastNameController.text.isEmpty)
                                      return 'Nome não pode ser vazio';
                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.4,
                                      textController: _lastNameController,
                                      enable: _isEnable,
                                      textInputType: TextInputType.text,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelText: 'Sobrenome',
                                      validator: (text) {},
                                    );
                                  }),
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
                              Icons.tag_faces,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_nicknameController.text.isEmpty)
                                      return 'Nickname não pode ser vazio';
                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.8,
                                      textController: _nicknameController,
                                      enable: _isEnable,
                                      textInputType: TextInputType.text,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelText: 'Nickname',
                                      validator: (text) {},
                                    );
                                  }),
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
                              Icons.email,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_emailController.text.isEmpty)
                                      return "E-mail não pode ser vazio!";
                                    else if (!emailValid(
                                        _emailController.text)) {
                                      debugPrint('email invalido');
                                      return 'E-mail Inválido!';
                                    }

                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.8,
                                      textController: _emailController,
                                      enable: _isEnable,
                                      textInputType: TextInputType.text,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelText: 'E-mail',
                                    );
                                  }),
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
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_numberController.text.isEmpty)
                                      return 'Número não pode ser vazia';
                                    else if (_numberController.text.length !=
                                        19) return 'Número Inválido';
                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.8,
                                      textController: _numberController,
                                      enable: _isEnable,
                                      textInputType: TextInputType.number,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelText: 'Telefone',
                                      inputFormatters: [
                                        celFormatter,
                                      ],
                                    );
                                  }),
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
                              child: FormField<String>(
                                  initialValue: '',
                                  validator: (text) {
                                    if (_passController.text.isEmpty)
                                      return 'Senha não pode ser vazia';
                                    return null;
                                  },
                                  builder: (state) {
                                    return CustomTextFormField(
                                      width: width * 0.8,
                                      textController: _passController,
                                      enable: _isEnable,
                                      textInputType: TextInputType.text,
                                      textColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      labelColor: state.hasError
                                          ? Colors.red
                                          : AppColors.mainColor,
                                      isObscure: _obscureTextPass,
                                      labelText: 'Senha',
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscureTextPass =
                                                  !_obscureTextPass;
                                            });
                                          },
                                          icon: Icon(_obscureTextPass
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 12.0,
                            bottom: 24.0,
                            left: width * 0.05,
                            right: width * 0.05),
                        child: CustomButton(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              // SET USER
                              var user = User(
                                  nickname: _nicknameController.text,
                                  name: _nameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phoneNumber: celFormatter
                                      .unmaskText(_numberController.text));

                              // debugPrint(user.toString());
                              setState(() {
                                _isEnable = false;
                              });
                              String response =
                                  await userManager.changeUserInfos(
                                      newUser: user,
                                      password: _passController.text,
                                      onSucess: _onSucess,
                                      onFailed: _onFailed);
                              setState(() {
                                _isEnable = true;
                              });

                              if (response == null)
                                _onSucess();
                              else
                                _onFailed();
                            }
                          },
                          verticalPad: 18.0,
                          color: AppColors.mainColor,
                          text: 'Atualizar Cadastro',
                          textColor: AppColors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (userManager.loading) ...[
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
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

  void _onSucess() async {
    mostrarSnackBar('Perfil Atualizado com sucesso!', Colors.green);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
  }

  void _onFailed() {
    mostrarSnackBar(
        'Erro ao atualizar, verifique seu email ou sua senha novamente',
        Colors.red);
  }
}
