import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/components/card_exercicio.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/components/info_exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/adicionar_exercicio.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

class MeusExerciciosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExercisesManager>(builder: (_, exerciciosManager, __) {
      return Scaffold(
          drawer: CustomDrawer(pageNow: 5),
          appBar: AppBar(
            toolbarHeight: 70,
            shadowColor: Colors.grey[850],
            elevation: 25,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 5.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                  ),
                  tooltip: 'Adicionar Novo Exercício',
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        enableDrag: false,
                        context: context,
                        builder: (_) => AdicionarExercicioModal());
                  },
                ),
              ),
            ],
            title: Text(
              "Meus Exercícios",
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: AppFonts.gothamBold,
                  fontSize: 24),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          backgroundColor: AppColors.grey,
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: exerciciosManager.listaMeusExercicios.length,
                itemBuilder: (_, index) {
                  return CardExercicio(
                    index: index,
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (_) => ExercicioInfoModal(
                              exercicio: exerciciosManager
                                  .listaMeusExercicios[index]));
                    },
                    exercise: exerciciosManager.listaMeusExercicios[index],
                  );
                }),
          ));
    });
  }
}
