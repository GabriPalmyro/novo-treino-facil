import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/helpers/email_valid.dart';
import '/app/core/app_colors.dart';
import '/app/core/core.dart';
import '/app/features/views/planilhas/components/custom_button.dart';

class NovoAlunoModal extends StatefulWidget {
  @override
  _NovoAlunoModalState createState() => _NovoAlunoModalState();
}

class _NovoAlunoModalState extends State<NovoAlunoModal> {
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void limparCampos() {
    setState(() {
      _emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets * 0.5,
          child: Container(
            height: height * 0.55,
            child: Container(
                height: height * 0.55,
                decoration: new BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: Padding(
                  padding: EdgeInsets.only(top: 18.0, right: 18, left: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adicionar Novo Aluno',
                        style: TextStyle(
                            fontFamily: AppFonts.gothamBold,
                            color: AppColors.white,
                            fontSize: 26.0),
                      ),
                      Divider(
                        color: AppColors.white,
                        thickness: 1,
                      ),
                      FormField<String>(
                          initialValue: '',
                          validator: (text) {
                            if (!emailValid(_emailController.text)) {
                              return "E-mail inválido.";
                            }
                            return null;
                          },
                          builder: (state) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'E-mail aluno:',
                                    style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: state.hasError
                                            ? Colors.red
                                            : AppColors.white,
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    width: width * 0.8,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.text,
                                      cursorColor: AppColors.mainColor,
                                      showCursor: true,
                                      style: TextStyle(
                                          fontFamily: AppFonts.gothamBook,
                                          color: state.hasError
                                              ? Colors.red
                                              : AppColors.white),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          width: width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                text: 'Limpar Campos',
                                color: AppColors.lightGrey,
                                textColor: AppColors.white,
                                onTap: () {
                                  limparCampos();
                                },
                              ),
                              CustomButton(
                                text: 'Confirmar',
                                color: AppColors.mainColor,
                                textColor: AppColors.black,
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {}
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
