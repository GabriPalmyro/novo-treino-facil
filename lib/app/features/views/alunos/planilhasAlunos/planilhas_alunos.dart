import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/card_planilha.dart';

class PlanilhaAlunoArguments {
  final String nomeUser;
  final String idUser;

  PlanilhaAlunoArguments({this.nomeUser, this.idUser});
}

class PlanilhaAlunoScreen extends StatefulWidget {
  final PlanilhaAlunoArguments arguments;

  PlanilhaAlunoScreen(this.arguments);

  @override
  _PlanilhaAlunoScreenState createState() => _PlanilhaAlunoScreenState();
}

class _PlanilhaAlunoScreenState extends State<PlanilhaAlunoScreen> {
  Future<List<Planilha>> loadPlanilha() async {
    Map<String, dynamic> data = {};
    List<Planilha> listaPlanilhas = List.empty(growable: true);
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.arguments.idUser)
          .collection("planilha")
          .get();

      queryWorksheet.docs.forEach((element) async {
        data = element.data();
        data['id'] = element.id;
        listaPlanilhas.add(Planilha.fromMap(data));
        data = {};
      });

      return listaPlanilhas;
    } catch (e) {
      listaPlanilhas = [];
      debugPrint('Erro: ' + e.toString());
      return listaPlanilhas;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanilhaManager>(builder: (_, planilhas, __) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          shadowColor: Colors.grey[850],
          elevation: 25,
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 28,
                ),
                tooltip: 'Adicionar Nova Planiha',
                onPressed: () {
                  // showModalBottomSheet(
                  //     backgroundColor: Colors.transparent,
                  //     isScrollControlled: true,
                  //     context: context,
                  //     builder: (_) => NovaPlanilhaModal());
                },
              ),
            ),
          ],
          title: AutoSizeText(
            "Planilhas de ${widget.arguments.nomeUser.split(' ').first}",
            style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.gothamBold,
                fontSize: 18),
          ),
          backgroundColor: AppColors.mainColor,
        ),
        backgroundColor: AppColors.grey,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: FutureBuilder<List>(
                future: loadPlanilha(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Buscando informações da suas planilhas',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontFamily: AppFonts.gothamBook,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        )
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 70.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children:
                                  List.generate(snapshot.data.length, (index) {
                                return CardPlanilha(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.exerciciosPlanilha,
                                        arguments: ExerciciosPlanilhaArguments(
                                            title: snapshot.data[index].title,
                                            idPlanilha: snapshot.data[index].id,
                                            idUser: widget.arguments.idUser,
                                            isPersonalAcess: true));
                                  },
                                  planilha: snapshot.data[index],
                                  index: index,
                                );
                              }),
                            ),
                          ),
                        );
                }),
          ),
        ),
      );
    });
  }
}
