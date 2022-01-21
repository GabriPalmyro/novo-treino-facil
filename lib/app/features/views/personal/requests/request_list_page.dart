import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

import 'components/card_request.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer2<UserManager, PersonalManager>(
        builder: (_, userManager, personalManager, __) {
      if (personalManager.loading)
        return Center(
          child: CircularProgressIndicator(),
        );
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            personalManager.personalRequestList.isEmpty
                ? Container(
                    height: height * 0.8,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied_rounded,
                            size: 52, color: AppColors.mainColor),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Você não possui nenhum\npedido de conexão",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: AppFonts.gothamBook,
                              color: Colors.white,
                              height: 1.2),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(7),
                    itemCount: personalManager.personalRequestList.length,
                    itemBuilder: (context, index) {
                      return CardRequest(
                        personal: personalManager.personalRequestList[index],
                        aceitarPedido: () async {
                          await showCustomDialogOpt(
                              context: context,
                              title: 'Aceitar Pedido?',
                              function: () async {
                                Navigator.pop(context);
                                String response =
                                    await personalManager.acceptPersonalRequest(
                                        personal: personalManager
                                            .personalRequestList[index],
                                        user: userManager.user);

                                if (response != null) {
                                  mostrarSnackBar(response, AppColors.red);
                                } else {
                                  await personalManager.loadMyPersonal(
                                      idUser: userManager.user.id);
                                }
                              },
                              message:
                                  'Ao realizar essa ação seus pedidos de conexão serão apagados e ${personalManager.personalRequestList[index].personalName.split(" ")[0]} será seu atual Personal.');
                        },
                        excluirPedido: () async {
                          await showCustomDialogOpt(
                              context: context,
                              title: 'Excluir Pedido?',
                              isDeleteMessage: true,
                              function: () async {
                                String response =
                                    await personalManager.deletePersonalRequest(
                                        requestId: personalManager
                                            .personalRequestList[index].id,
                                        userId: userManager.user.id);

                                if (response != null) {
                                  mostrarSnackBar(response, AppColors.red);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              message:
                                  'Ao realizar essa ação o pedido de conexão de ${personalManager.personalRequestList[index].personalName} será excluído.');
                        },
                      );
                    })
          ],
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
}
