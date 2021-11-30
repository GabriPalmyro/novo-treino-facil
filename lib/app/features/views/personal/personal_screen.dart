import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/util/util_brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/helpers/date_format.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalScreen extends StatefulWidget {
  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String _showNumber(String numberOld) {
    String number = UtilBrasilFields.removeCaracteres(numberOld);

    var ddd = number.substring(2, 4);
    var numberPhone1 = number.substring(4, 9);
    var numberPhone2 = number.substring(9, 13);
    return "(" + ddd + ")" + " " + numberPhone1 + "-" + numberPhone2;
  }

  _sendWhatsAppMessage({@required String phoneOld}) async {
    String phone = UtilBrasilFields.removeCaracteres(phoneOld);

    String message = "Olá, estou com dúvidas, você pode me ajudar?";
    //var whatsappUrl = "whatsapp://send?phone=$phone=$message";
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    await launch(url());
  }

  int _calcTime(dateTime) {
    return DateTime.now().difference(dateTime).inDays;
  }

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPersonal();
  }

  Future<void> loadPersonal() async {
    await Future.delayed(Duration(seconds: 1));
    await context.read<PersonalManager>().loadMyPersonal();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
        return true;
      },
      child: Consumer<PersonalManager>(builder: (_, personalManager, __) {
        return Scaffold(
          drawer: CustomDrawer(pageNow: 4),
          appBar: AppBar(
            toolbarHeight: 70,
            shadowColor: Colors.grey[850],
            elevation: 25,
            centerTitle: false,
            title: AutoSizeText(
              "Meu Personal Trainer",
              maxFontSize: 24,
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.gothamBold,
              ),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          backgroundColor: AppColors.grey,
          body: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(color: Colors.grey[900]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
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
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                    personalManager.personal.personalPhoto,
                                    fit: BoxFit.cover, loadingBuilder:
                                        (BuildContext context, Widget child,
                                            ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              personalManager.personal.personalName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.gothamThin,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vocês estão conectados há",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.gothamThin,
                                      fontSize: 18),
                                ),
                                Text(
                                  " ${_calcTime(personalManager.personal.connectionDate)} dias",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: AppFonts.gothamThin,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "${dateFormater(personalManager.personal.connectionDate)}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Text(
                              "E-mail",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontFamily: AppFonts.gotham,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              personalManager.personal.personalEmail,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.gothamThin,
                                  fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Text(
                              "Número",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontFamily: AppFonts.gotham,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _showNumber(
                                  personalManager.personal.personalPhone),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.gothamThin,
                                  fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _sendWhatsAppMessage(
                                  phoneOld:
                                      personalManager.personal.personalPhone);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 30),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 40,
                              child: Center(
                                child: Text(
                                  "Enviar Mensagem",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.gothamBook,
                                      fontSize: 12),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 2,
                                        offset: Offset(0, 4))
                                  ]),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(right: 30),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 40,
                              child: Center(
                                child: Text(
                                  "Desconectar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.gothamBook,
                                      fontSize: 12),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 2,
                                        offset: Offset(0, 4))
                                  ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
