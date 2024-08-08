import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/card_planilha.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

import 'components/info_dialog.dart';
import 'components/lista_planilha_vazia.dart';
import 'components/nova_planilha_modal.dart';

class PlanilhaScreen extends StatefulWidget {
  final bool isPersonalAcess;
  PlanilhaScreen({this.isPersonalAcess = false});
  @override
  _PlanilhaScreenState createState() => _PlanilhaScreenState();
}

class _PlanilhaScreenState extends State<PlanilhaScreen> {
  //*ADS
  // final _controller = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanilhaManager>(builder: (_, planilhas, __) {
      return Scaffold(
        // drawer: CustomDrawer(pageNow: 1),
        appBar: AppBar(
          toolbarHeight: 70,
          // shadowColor: Colors.grey[850],
          iconTheme: IconThemeData(
            color: AppColors.mainColor,
          ),
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.circleInfo,
                size: 25,
              ),
              tooltip: 'Info',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InfoDialog();
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.circlePlus,
                  size: 25,
                ),
                tooltip: 'Adicionar Nova Planiha',
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => NovaPlanilhaModal(
                      idUser: context.read<UserManager>().user.id!,
                      isPersonalAcess: widget.isPersonalAcess,
                    ),
                  );
                },
              ),
            ),
          ],
          title: Text(
            "Planilhas",
            style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gothamBold, fontSize: 30),
          ),
          backgroundColor: AppColors.grey,
        ),
        backgroundColor: AppColors.grey,
        body: planilhas.loading
            ? ExerciciosPlanilhaShimmer()
            : planilhas.listaPlanilhas.isEmpty
                ? PlanilhasVazia(onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => NovaPlanilhaModal(
                              idUser: context.read<UserManager>().user.id!,
                              isPersonalAcess: widget.isPersonalAcess,
                            ));
                  })
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(planilhas.listaPlanilhas.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Column(
                              children: [
                                // TODO (ADS) - Implementar ADS Novamente
                                // if (index % 3 == 0 && index != 0) ...[
                                //   Container(
                                //     height: 90,
                                //     padding: EdgeInsets.all(10),
                                //     child: NativeAdmob(
                                //       adUnitID: nativeAdUnitId(),
                                //       loading: Center(
                                //         child: CircularProgressIndicator(
                                //           strokeWidth: 1.5,
                                //           color: AppColors.mainColor,
                                //           backgroundColor: AppColors.mainColor.withOpacity(0.5),
                                //         ),
                                //       ),
                                //       error: Center(
                                //         child: Text(
                                //           "Falha ao carregar anúncio...",
                                //           style: TextStyle(fontFamily: AppFonts.gothamLight, color: AppColors.mainColor.withOpacity(0.6), fontSize: 14),
                                //         ),
                                //       ),
                                //       numberAds: 3,
                                //       controller: _controller,
                                //       type: NativeAdmobType.banner,
                                //     ),
                                //   ),
                                // ],
                                CardPlanilha(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.exerciciosPlanilha,
                                        arguments: ExerciciosPlanilhaArguments(
                                            title: planilhas.listaPlanilhas[index].title!,
                                            idPlanilha: planilhas.listaPlanilhas[index].id!,
                                            idUser: context.read<UserManager>().user.id!,
                                            isFriendAcess: false,
                                            isPersonalAcess: widget.isPersonalAcess));
                                  },
                                  userId: context.read<UserManager>().user.id!,
                                  planilha: planilhas.listaPlanilhas[index],
                                  index: index,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
      );
    });
  }
}
