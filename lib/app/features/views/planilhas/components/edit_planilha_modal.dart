import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/dia_da_semana.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/select_diasemana.dart';

class EditPlanilhaModal extends StatefulWidget {
  final Planilha planilha;
  final int index;

  const EditPlanilhaModal({@required this.planilha, @required this.index});

  @override
  _EditPlanilhaModalState createState() => _EditPlanilhaModalState();
}

class _EditPlanilhaModalState extends State<EditPlanilhaModal> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DiaDaSemana> _diasDaSemana = [];

  void resetCampos() {
    setState(() {
      _titleController.text = widget.planilha.title;
      _descriptionController.text = widget.planilha.description;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.planilha.title;
    _descriptionController.text = widget.planilha.description;
    _diasDaSemana = widget.planilha.diasDaSemana;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<PlanilhaManager>(builder: (_, planilhaManager, __) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets * 0.5,
          child: Container(
            height: height * 0.65,
            child: Container(
                height: height * 0.65,
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
                        'Editar Planiilha',
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
                            if (_titleController.text.isEmpty) {
                              return "O campo título não pode estar vazio.";
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
                                    'Nome Planilha:',
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
                                      controller: _titleController,
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
                      FormField(
                          initialValue: '',
                          validator: (text) {
                            if (_descriptionController.text.isEmpty) {
                              return "O campo descrição não pode estar vazio.";
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
                                    'Descrição Planilha:',
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
                                      controller: _descriptionController,
                                      keyboardType: TextInputType.text,
                                      cursorColor: AppColors.mainColor,
                                      maxLines: null,
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
                        child: Text(
                          'Dia da Semana:',
                          style: TextStyle(
                              fontFamily: AppFonts.gothamBook,
                              color: AppColors.white,
                              fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) => SelectDiaSemanaModal(
                                      diasDaSemana: _diasDaSemana,
                                    ));
                          },
                          child: Container(
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Selecionar dias da semana',
                                      style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                      )),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.white,
                                  )
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          width: width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                text: 'Redefinir',
                                color: AppColors.lightGrey,
                                textColor: AppColors.white,
                                onTap: () {
                                  resetCampos();
                                },
                              ),
                              CustomButton(
                                text: 'Confirmar',
                                color: AppColors.mainColor,
                                textColor: AppColors.black,
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    Planilha planilha = Planilha(
                                        id: widget.planilha.id,
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        diasDaSemana: _diasDaSemana,
                                        favorito: widget.planilha.favorito);
                                    await planilhaManager.editPlanilha(
                                        planilha, widget.index);
                                    Navigator.pop(context);
                                  }
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
