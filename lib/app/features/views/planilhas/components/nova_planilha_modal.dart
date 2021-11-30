import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/models/planilha/dia_da_semana.dart';
import '/app/core/app_colors.dart';
import '/app/core/core.dart';
import '/app/features/controllers/planilha/planilha_manager.dart';
import '/app/features/models/planilha/planilha.dart';
import '/app/features/views/planilhas/components/custom_button.dart';
import '/app/features/views/planilhas/components/select_diasemana.dart';

class NovaPlanilhaModal extends StatefulWidget {
  @override
  _NovaPlanilhaModalState createState() => _NovaPlanilhaModalState();
}

class _NovaPlanilhaModalState extends State<NovaPlanilhaModal> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DiaDaSemana> diasDaSemana = [
    DiaDaSemana(dia: 'Segunda-Feira', isSelected: false),
    DiaDaSemana(dia: 'Terça-Feira', isSelected: false),
    DiaDaSemana(dia: 'Quarta-Feira', isSelected: false),
    DiaDaSemana(dia: 'Quinta-Feira', isSelected: false),
    DiaDaSemana(dia: 'Sexta-Feira', isSelected: false),
    DiaDaSemana(dia: 'Sábado', isSelected: false),
    DiaDaSemana(dia: 'Domingo', isSelected: false),
  ];

  void limparCampos() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
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
            height: height * 0.75,
            child: Container(
                height: height * 0.75,
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
                        'Criar Nova Planiilha',
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
                                      diasDaSemana: diasDaSemana,
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
                                  if (_formKey.currentState.validate()) {
                                    Planilha planilha = Planilha(
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        diasDaSemana: diasDaSemana,
                                        favorito: false);
                                    await planilhaManager
                                        .createNovaPlanilha(planilha);
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
