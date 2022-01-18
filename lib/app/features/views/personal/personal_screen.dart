import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/personal/meuPersonal/meu_personal_page.dart';
import 'package:tabela_treino/app/features/views/personal/requests/request_list_page.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

class PersonalScreen extends StatefulWidget {
  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPersonal();
  }

  Future<void> loadPersonal() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<PersonalManager>()
          .loadMyPersonal(idUser: context.read<UserManager>().user.id);
      await context.read<PersonalManager>().loadMyPersonalRequestList(
          idUser: context.read<UserManager>().user.id);
      setState(() {
        loading = false;
      });
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
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
              drawer: CustomDrawer(
                pageNow: 4,
              ),
              appBar: AppBar(
                title: Text(
                  "Meu Personal",
                  style:
                      TextStyle(fontFamily: AppFonts.gothamBold, fontSize: 20),
                ),
                centerTitle: true,
                bottom: TabBar(
                    indicatorColor: Colors.white,
                    overlayColor: MaterialStateProperty.all(AppColors.grey300),
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.person_outline,
                          size: 30,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.list,
                          size: 30,
                        ),
                      )
                    ]),
              ),
              backgroundColor: Color(0xff313131),
              body: TabBarView(
                children: [
                  //TAB 1
                  MeuPersonalPage(),
                  //TAB 2
                  RequestListPage()
                ],
              ))),
    );
  }
}
