import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';

class ExerciciosInfoPage extends StatefulWidget {
  final TextEditingController titleController;
  final String agrupamentoMusc;
  final List<String> titles;
  final Function(String?) onChanged;
  final VoidCallback changePage;
  final Function(int) changeDificuldade;
  final Function(bool) changeIsHomeExe;
  final int dificuldade;
  final bool isHomeExe;
  final GlobalKey formKey;

  const ExerciciosInfoPage(
      {required this.titleController,
      required this.agrupamentoMusc,
      required this.titles,
      required this.dificuldade,
      required this.changeDificuldade,
      required this.changeIsHomeExe,
      required this.isHomeExe,
      required this.onChanged,
      required this.changePage,
      required this.formKey});

  @override
  _ExerciciosInfoPageState createState() => _ExerciciosInfoPageState();
}

class _ExerciciosInfoPageState extends State<ExerciciosInfoPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 18, left: 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: AppColors.mainColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Aqui você pode adicionar os seus exercícios próprios para utilizar em suas planilhas...',
                  style: TextStyle(
                      height: 1.1,
                      fontFamily: AppFonts.gothamBold,
                      color: AppColors.white,
                      fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Siga os passos a seguir para adicionar um exercício em sua própria biblioteca!',
                  style: TextStyle(
                      fontFamily: AppFonts.gothamBook,
                      color: AppColors.white,
                      fontSize: 18.0),
                ),
              ),
              Divider(
                color: AppColors.white,
                thickness: 1,
              ),
              FormField<String>(
                  initialValue: '',
                  validator: (text) {
                    if (widget.titleController.text.isEmpty) {
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
                            'Título:',
                            style: TextStyle(
                                fontFamily: AppFonts.gothamBold,
                                color: state.hasError
                                    ? Colors.red
                                    : AppColors.white,
                                fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: widget.titleController,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      'Agrupamento Muscular:',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamBold,
                          color: AppColors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: false,
                            underline: SizedBox(),
                            icon: SizedBox(),
                            hint: AutoSizeText(
                              'Agrupamento',
                              style: TextStyle(
                                fontFamily: AppFonts.gothamBook,
                                color: AppColors.black,
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: AppColors.lightGrey,
                            value: widget.agrupamentoMusc,
                            items: widget.titles
                                .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      color: AppColors.lightGrey,
                                      child: Center(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: AppFonts.gothamBook,
                                            color: AppColors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )))
                                .toList(),
                            onChanged: widget.onChanged),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      'Dificuldade:',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamBold,
                          color: AppColors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        width: width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                                onPressed: () {
                                  widget.changeDificuldade(index);
                                },
                                icon: Icon(
                                  widget.dificuldade > index
                                      ? Icons.star
                                      : Icons.star_border_outlined,
                                  color: AppColors.mainColor,
                                ));
                          }),
                        )),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      'Pode ser realizado em casa?',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamBold,
                          color: AppColors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: width * 0.9,
                        height: 60,
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              widget.changeIsHomeExe(false);
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: !widget.isHomeExe
                                      ? AppColors.mainColor
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: widget.isHomeExe
                                          ? AppColors.mainColor
                                          : Colors.transparent,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Center(
                                child: Text(
                                  'Não',
                                  style: TextStyle(
                                      fontFamily: AppFonts.gothamBook,
                                      color: !widget.isHomeExe
                                          ? AppColors.grey
                                          : AppColors.mainColor,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24.0),
                            child: InkWell(
                              onTap: () {
                                widget.changeIsHomeExe(true);
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: widget.isHomeExe
                                        ? AppColors.mainColor
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: !widget.isHomeExe
                                            ? AppColors.mainColor
                                            : Colors.transparent,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                  child: Text(
                                    'Sim',
                                    style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: widget.isHomeExe
                                            ? AppColors.grey
                                            : AppColors.mainColor,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    text: 'ADICIONAR VÍDEO',
                    color: AppColors.mainColor,
                    textColor: AppColors.black,
                    verticalPad: 16,
                    onTap: widget.changePage,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
