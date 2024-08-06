import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/planilha_vazia.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/components/info_exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/adicionar_exercicio.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

import 'components/card_meu_exercicio.dart';

class MeusExerciciosScreen extends StatefulWidget {
  @override
  _MeusExerciciosScreenState createState() => _MeusExerciciosScreenState();
}

class _MeusExerciciosScreenState extends State<MeusExerciciosScreen> {
  bool loading = true;

  Future<void> loadMyExercises() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String idUser = context.read<UserManager>().user.id!;
      await context
          .read<ExercisesManager>()
          .loadMyListExercises(idUser: idUser);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExercisesManager>(builder: (_, exerciciosManager, __) {
      return Scaffold(
          // drawer: CustomDrawer(pageNow: 8),
          appBar: AppBar(
            toolbarHeight: 70,
            // shadowColor: Colors.grey[850],
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
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
                  color: AppColors.mainColor,
                  fontFamily: AppFonts.gothamBold,
                  fontSize: 24),
            ),
            backgroundColor: AppColors.grey,
          ),
          backgroundColor: AppColors.grey,
          body: loading
              ? ExerciciosPlanilhaShimmer()
              : exerciciosManager.listaMeusExercicios.isEmpty
                  ? ExerciciosPlanilhaVazia(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            enableDrag: false,
                            context: context,
                            builder: (_) => AdicionarExercicioModal());
                      },
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: exerciciosManager.listaMeusExercicios.length,
                      itemBuilder: (_, index) {
                        return CardMeuExercicio(
                          index: index,
                          deleteExercise: () async {
                            String userId = context.read<UserManager>().user.id!;
                            
                            final response = await exerciciosManager
                                .deleteMyExercise(index: index, userId: userId);

                            if (response != null) {
                              Navigator.pop(context);
                              mostrarSnackBar(
                                  message:
                                      'Não foi possível excluir esse exercício.',
                                  color: AppColors.red,
                                  context: context);
                            } else {
                              Navigator.pop(context);
                              mostrarSnackBar(
                                  message: 'Exercício excluído com sucesso.',
                                  color: Colors.green,
                                  context: context);
                            }
                          },
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
                          exercise:
                              exerciciosManager.listaMeusExercicios[index],
                        );
                      }));
    });
  }
}
