import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsManager extends ChangeNotifier {
  SharedPreferences prefs;

  int _paddingAds = 60;

  set paddingAds(int value) => _paddingAds;

  get paddingAds => _paddingAds;

  //* RESET ADS
  Future<void> resetAdsPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('edit_exercicio_ad', true);
    await prefs.setInt('add_exercicio_ad', 0);
  }

  //* EDITAR EXERCICIO
  Future<bool> getIsAvaliableToShowAdEditExercise() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool('edit_exercicio_ad') ?? true;
  }

  Future<void> setIsAvaliableToShowAdEditExercise(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('edit_exercicio_ad', value);
  }

  //* VEZES QUE ADICIONOU EXERCÍCIO
  Future<int> getSeenTimesAddExercice() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt('add_exercicio_ad') ?? 0;
  }

  Future<void> setSeenTimesAddExercice(int value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('add_exercicio_ad', value);
  }

  //* ADICIONAR PLANILHA
  Future<void> setIsAvaliableNewPlanilha(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('new_planilha_add', value);
  }

  Future<bool> getIsAvaliableNewPlanilha() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool('new_planilha_add') ?? true;
  }

  //* VEZES QUE VIU EXERCÍCIO LISTA
  Future<void> setSeenTimesExerciciosLista(int value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lista_exercicios_add', value);
  }

  Future<int> getSeenTimesExerciciosLista() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lista_exercicios_add') ?? 0;
  }

  //* ENTROU PERFIL AMIGO
  Future<void> setSeenTimesAmigosPerfil(int value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('amigos_perfil_add', value);
  }

  Future<int> getSeenTimesAmigosPerfil() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt('amigos_perfil_add') ?? 0;
  }
}
