import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/card_planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/lista_planilha_vazia.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/nova_planilha_modal.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

class PlanilhaAlunoArguments {
  final String nomeUser;
  final String idUser;

  PlanilhaAlunoArguments({required this.nomeUser, required this.idUser});
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
      var queryWorksheet = await FirebaseFirestore.instance.collection("users").doc(widget.arguments.idUser).collection("planilha").orderBy('title').get();

      queryWorksheet.docs.forEach((element) async {
        data = element.data();
        data['id'] = element.id;
        listaPlanilhas.add(Planilha.fromMap(data));
        data = {};
      });
      return listaPlanilhas;
    } catch (e) {
      listaPlanilhas = [];
      log('Erro: ' + e.toString());
      return listaPlanilhas;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanilhaManager>(
      builder: (_, planilhas, __) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
            toolbarHeight: 60,
            // shadowColor: Colors.grey[850],
            elevation: 0,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.mainColor,
                    size: 28,
                  ),
                  tooltip: 'Adicionar Nova Planiha',
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => NovaPlanilhaModal(
                              idUser: widget.arguments.idUser,
                              isPersonalAcess: true,
                            ));
                  },
                ),
              ),
            ],
            title: AutoSizeText(
              "Planilhas de ${widget.arguments.nomeUser}",
              maxLines: 2,
              style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gothamBold, fontSize: 18),
            ),
            backgroundColor: AppColors.grey,
          ),
          backgroundColor: AppColors.grey,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: FutureBuilder<List<Planilha>>(
                future: loadPlanilha(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? ExerciciosPlanilhaShimmer()
                      : snapshot.data!.isEmpty
                          ? PlanilhasVazia(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) => NovaPlanilhaModal(
                                          idUser: widget.arguments.idUser,
                                          isPersonalAcess: true,
                                        ));
                              },
                            )
                          : SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 70.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    snapshot.data!.length,
                                    (index) {
                                      final planilha = snapshot.data![index];
                                      return Padding(
                                        padding: EdgeInsets.only(top: index != 0 ? 24.0 : 8),
                                        child: CardPlanilha(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.exerciciosPlanilha,
                                              arguments: ExerciciosPlanilhaArguments(
                                                title: planilha.title!,
                                                idPlanilha: planilha.id!,
                                                idUser: widget.arguments.idUser,
                                                isPersonalAcess: true,
                                                isFriendAcess: false,
                                                nomeAluno: widget.arguments.nomeUser,
                                              ),
                                            );
                                          },
                                          userId: widget.arguments.idUser,
                                          planilha: planilha,
                                          index: index,
                                          isPersonalAcess: true,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
