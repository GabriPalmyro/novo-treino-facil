import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';

import 'components/card_exercicio.dart';
import 'components/filter_button.dart';
import 'components/info_exercicio_modal.dart';

class ListaExerciciosScreen extends StatefulWidget {
  @override
  _ListaExerciciosScreenState createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen> {
  //* ADS
  // InterstitialAd interstitialAdMuscle;
  // bool isInterstitialReady = false;

  // void _loadInterstitialAd() {
  //   interstitialAdMuscle.load();
  // }

  // void _onInterstitialAdEvent(MobileAdEvent event) {
  //   switch (event) {
  //     case MobileAdEvent.loaded:
  //       isInterstitialReady = true;
  //       break;
  //     case MobileAdEvent.failedToLoad:
  //       log('Failed to load an interstitial ad. Error: $event'.toUpperCase());
  //       isInterstitialReady = false;
  //       break;
  //     default:
  //     // do nothing
  //   }
  // }

  @override
  void initState() {
    super.initState();
    carregarMeusExercicios();
    _searchController.addListener(_onSearchChanged);
    // interstitialAdMuscle = InterstitialAd(
    //   adUnitId: interstitialAdUnitId(),
    //   listener: _onInterstitialAdEvent,
    // );
    // _loadInterstitialAd();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ExercisesManager>().searchResultList(searchController: _searchController.text, selectedType: _selTypeSearch);
  }

  Future<void> carregarMeusExercicios() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String id = context.read<UserManager>().user.id!;
      await context.read<ExercisesManager>().loadMyListExercises(idUser: id);
    });
  }

  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _selTypeSearch = "title";

  //*ADS
  // final _controller = NativeAdmobController();

  Widget _buildSearchField() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _searchController,
      style: TextStyle(
        color: AppColors.mainColor.withOpacity(0.8),
        fontSize: 20,
        height: 1.3,
        fontFamily: AppFonts.gothamBook,
      ),
      enableInteractiveSelection: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 5),
        hintText: _selTypeSearch == "mines"
            ? "Meus Exercícios"
            : _selTypeSearch == "title"
                ? "Procure um exercício"
                : _selTypeSearch == "home_exe"
                    ? "Fazer em casa"
                    : _selTypeSearch == "muscleId"
                        ? "Procure um músculo"
                        : "Procure em $_selTypeSearch",
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 18,
          color: AppColors.mainColor.withOpacity(0.8),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                _isSearching = false;
              });
              return;
            }
            setState(() {
              _searchController.clear();
            });
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        padding: EdgeInsets.only(right: 30),
        icon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
    ];
  }

  List filters = [
    "mines",
    "title",
    "home_exe",
    "abdomen",
    "biceps",
    "costas",
    "ombros",
    "peitoral",
    "pernas",
    "triceps",
  ];

  List titles = [
    "Meus Exercícios",
    "Título",
    "Fazer em casa",
    "Abdômen",
    "Bíceps",
    "Costas",
    "Ombros",
    "Peitoral",
    "Pernas",
    "Tríceps",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ExercisesManager>(builder: (_, exercicios, __) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.mainColor,
          ),
          elevation: 0,
          backgroundColor: AppColors.grey,
          title: _isSearching
              ? _buildSearchField()
              : Text(
                  "Exercícios",
                  style: TextStyle(fontFamily: AppFonts.gothamBold, color: AppColors.mainColor, fontSize: 30),
                  maxLines: 2,
                ),
          actions: _buildActions(),
          //leading: (addMode && exeId != null) ? Container() : null,
          centerTitle: true,
        ),
        backgroundColor: AppColors.grey,
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 12),
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: List.generate(filters.length, (index) {
                        return FilterButton(
                          onTap: () {
                            setState(() {
                              _selTypeSearch = filters[index];
                              exercicios.searchResultList(searchController: _searchController.text, selectedType: _selTypeSearch);
                            });
                          },
                          filter: filters[index],
                          selectedType: _selTypeSearch,
                          title: titles[index],
                        );
                      }),
                    ),
                  ),
                )),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: exercicios.resultList.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: (index + 1) == exercicios.resultList.length ? 60.0 : 0),
                      child: Column(
                        children: [
                          // if (index % 8 == 0 && index != 0) ...[
                          //   Container(
                          //     height: 90,
                          //     padding: EdgeInsets.all(10),
                          //     child: NativeAdmob(
                          //       adUnitID: nativeAdUnitId(),
                          //       loading: Center(
                          //         child: CircularProgressIndicator(
                          //           strokeWidth: 1.5,
                          //           color: AppColors.mainColor,
                          //           backgroundColor:
                          //               AppColors.mainColor.withOpacity(0.5),
                          //         ),
                          //       ),
                          //       error: Center(
                          //         child: Text(
                          //           "Falha ao carregar anúncio...",
                          //           style: TextStyle(
                          //               fontFamily: AppFonts.gothamLight,
                          //               color: AppColors.mainColor
                          //                   .withOpacity(0.6),
                          //               fontSize: 14),
                          //         ),
                          //       ),
                          //       numberAds: 3,
                          //       controller: _controller,
                          //       type: NativeAdmobType.banner,
                          //     ),
                          //   ),
                          // ],
                          CardExercicio(
                            index: index,
                            onTap: () async {
                              // if (isInterstitialReady) {
                              //   SharedPreferences prefs =
                              //       await SharedPreferences.getInstance();

                              //   //* VALIDAR ANÚNCIO INTERCALADO 3
                              //   int adSeenTimes =
                              //       prefs.getInt('view_exercicio') ?? 0;
                              //   if (adSeenTimes < 3) {
                              //     await prefs.setInt(
                              //         'view_exercicio', adSeenTimes + 1);
                              //   } else {
                              //     await interstitialAdMuscle.show();
                              //     await prefs.setInt('view_exercicio', 0);
                              //   }

                              //   await interstitialAdMuscle.load();
                              // }

                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  context: context,
                                  builder: (_) => ExercicioInfoModal(exercicio: exercicios.resultList[index]));
                            },
                            exercise: exercicios.resultList[index],
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }
}
