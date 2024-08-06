import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/meAjuda/ajudas_controller.dart';
import 'package:tabela_treino/app/features/views/meAjuda/shimmer_ajuda.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

import 'ajuda_details.dart';

class MeAjudaScreen extends StatefulWidget {
  @override
  _MeAjudaScreenState createState() => _MeAjudaScreenState();
}

class _MeAjudaScreenState extends State<MeAjudaScreen> {
  //*ADS
  // final _controller = NativeAdmobController();

  bool isLoading = true;

  Future<void> getAjudas() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MeAjudaController>().getListaAjudas();
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAjudas();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeAjudaController>(
      builder: (_, meAjuda, __) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
            title: Text(
              'Me Ajuda',
              style: TextStyle(fontFamily: AppFonts.gothamBold, color: AppColors.mainColor, fontSize: 24.0),
            ),
            centerTitle: true,
            backgroundColor: AppColors.grey,
          ),
          drawer: CustomDrawer(
            pageNow: 12,
          ),
          backgroundColor: AppColors.grey,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: isLoading
                ? Container(
                    child: Shimmer.fromColors(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          6,
                          (index) => ShimmerAjuda(),
                        ),
                      ),
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.lightGrey.withOpacity(0.6),
                    ),
                  )
                : Column(
                    children: List.generate(
                      meAjuda.listaAjudas.length,
                      (index) => !meAjuda.listaAjudas[index].show!
                          ? SizedBox()
                          : Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      enableDrag: false,
                                      context: context,
                                      builder: (_) => AjudaDetailsScreen(
                                        title: meAjuda.listaAjudas[index].title!,
                                        description: meAjuda.listaAjudas[index].description!,
                                        link: meAjuda.listaAjudas[index].link!,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(18.0, 12.0, 32.0, 12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                meAjuda.listaAjudas[index].title!,
                                                style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.white, fontSize: 20.0),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: AutoSizeText(
                                                  meAjuda.listaAjudas[index].description!,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontFamily: AppFonts.gothamLight, color: AppColors.white.withOpacity(0.6), fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // if (index == meAjuda.listaAjudas.length - 1) ...[
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
                              ],
                            ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
