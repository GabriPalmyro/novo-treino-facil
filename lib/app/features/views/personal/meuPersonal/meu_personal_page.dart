import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/helpers/numer_format.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MeuPersonalPage extends StatefulWidget {
  @override
  _MeuPersonalPageState createState() => _MeuPersonalPageState();
}

class _MeuPersonalPageState extends State<MeuPersonalPage> {
  Future<void> sendWhatsAppMessage({required String phoneOld}) async {
    String phone = UtilBrasilFields.removeCaracteres(phoneOld);

    String message = "Olá, estou com dúvidas, você pode me ajudar?";
    String whatsappUrl;
    if (Platform.isAndroid) {
      // add the [https]
      whatsappUrl = "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      whatsappUrl = "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }

    await launchUrl(Uri.tryParse(whatsappUrl)!);
  }

  int _calcTime(dateTime) {
    return DateTime.now().difference(dateTime).inDays;
  }

  Future<void> showCustomDialogOpt({required VoidCallback VoidCallBack, required String message,}) async {
    await showCustomAlertDialog(
        title: Text(
          'Deseja se desconectar?',
          style: TextStyle(fontFamily: AppFonts.gothamBold, color: AppColors.mainColor),
        ),
        androidActions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar', style: TextStyle(fontFamily: AppFonts.gotham, color: Colors.white))),
          TextButton(onPressed: VoidCallBack, child: Text('Ok', style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
        ],
        iosActions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar', style: TextStyle(fontFamily: AppFonts.gotham, color: Colors.white))),
          TextButton(onPressed: VoidCallBack, child: Text('Ok', style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
        ],
        context: context,
        content: Text(
          message,
          style: TextStyle(height: 1.1, fontFamily: AppFonts.gotham, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalManager>(builder: (_, personalManager, __) {
      if (personalManager.loading)
        return Center(
          child: CircularProgressIndicator(),
        );
      if (personalManager.personal.id == null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied_rounded, size: 52, color: AppColors.mainColor),
            SizedBox(
              height: 5,
            ),
            Text(
              "Você não possui nenhum\nPersonal Trainer ativo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontFamily: AppFonts.gothamBook, color: Colors.white, height: 1.2),
            ),
          ],
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey[900]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.network(personalManager.personal.personalPhoto!, fit: BoxFit.cover,
                            loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    personalManager.personal.personalName ?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamThin, fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vocês estão conectados há",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamThin, fontSize: 18),
                      ),
                      Text(
                        " ${_calcTime(personalManager.personal.connectionDate)} dias",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.green, fontFamily: AppFonts.gothamThin, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    "E-mail",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: AppFonts.gotham, fontSize: 24),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    personalManager.personal.personalEmail?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamThin, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    "Número",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: AppFonts.gotham, fontSize: 24),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    showNumber(personalManager.personal.personalPhone ?? ''),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamThin, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    await sendWhatsAppMessage(phoneOld: personalManager.personal.personalPhone ?? '');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Enviar Mensagem",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamBook, fontSize: 12),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 2, offset: Offset(0, 4))]),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await showCustomDialogOpt(
                      message:
                          'Desconectar de ${personalManager.personal.personalName!.split(' ')[0]} irá resultar na perda do controle sobre suas planilhas e treinos.',
                      VoidCallBack: () async {
                        final response = await context
                            .read<UserManager>()
                            .deletePersonalAlunoConnection(personalId: context.read<UserManager>().user.id!, userId: personalManager.personal.personalId!);

                        if (response != null) {
                          Navigator.pop(context);
                          mostrarSnackBar(message: response, color: AppColors.red, context: context);
                        } else {
                          personalManager.disconectPersonal();
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Desconectar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontFamily: AppFonts.gothamBook, fontSize: 12),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 2, offset: Offset(0, 4))]),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
