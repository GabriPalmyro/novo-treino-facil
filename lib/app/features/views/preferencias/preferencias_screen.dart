import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/preferencias/components/preferencias_card.dart';
import 'package:tabela_treino/app/features/views/preferencias/components/preferencias_options.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

class PreferenciasScreen extends StatefulWidget {
  @override
  _PreferenciasScreenState createState() => _PreferenciasScreenState();
}

class _PreferenciasScreenState extends State<PreferenciasScreen> {
  bool mostrarPlanilhas = false;
  bool mostrarExercicios = false;
  bool mostrarPerfilPesquisa = false;

  @override
  void initState() {
    super.initState();
    mostrarPlanilhas = context.read<UserManager>().user.mostrarPlanilhasPerfil;
    mostrarExercicios =
        context.read<UserManager>().user.mostrarExerciciosPerfil;
    mostrarPerfilPesquisa =
        context.read<UserManager>().user.mostrarPerfilPesquisa;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Scaffold(
        drawer: CustomDrawer(pageNow: 8),
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey[850],
          elevation: 25,
          title: Text(
            "Preferências",
            style: TextStyle(
                color: Colors.grey[850],
                fontFamily: AppFonts.gothamBold,
                fontSize: 30),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  String response = await userManager.changeUserPreferences(
                      mostrarPlanilhas: mostrarPlanilhas,
                      mostrarExercicios: mostrarExercicios,
                      mostrarPerfilPesquisa: mostrarPerfilPesquisa);

                  if (response != null) {
                    //TODO MOSTRAR SNACKBAR
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.save,
                  color: AppColors.grey,
                ))
          ],
          backgroundColor: AppColors.mainColor,
        ),
        backgroundColor: const Color(0xff313131),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: PreferenciasCard(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Planilhas',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamBold,
                          color: AppColors.white,
                          fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: PreferenciasOptions(
                          labelText: 'Mostrar minhas planilhas',
                          isActive: mostrarPlanilhas,
                          onTap: () {
                            setState(() {
                              mostrarPlanilhas = !mostrarPlanilhas;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: PreferenciasOptions(
                          labelText: 'Mostrar meus exercícios',
                          isActive: mostrarExercicios,
                          onTap: () {
                            setState(() {
                              mostrarExercicios = !mostrarExercicios;
                            });
                          }),
                    ),
                  ],
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: PreferenciasCard(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Amigos',
                      style: TextStyle(
                          fontFamily: AppFonts.gothamBold,
                          color: AppColors.white,
                          fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: PreferenciasOptions(
                          labelText:
                              'Permitir que meu perfil apareça em pesquisas',
                          isActive: mostrarPerfilPesquisa,
                          onTap: () {
                            setState(() {
                              mostrarPerfilPesquisa = !mostrarPerfilPesquisa;
                            });
                          }),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
