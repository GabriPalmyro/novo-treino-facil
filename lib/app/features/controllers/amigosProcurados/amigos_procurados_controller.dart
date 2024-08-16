import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';

class AmigosProcuradosManager extends ChangeNotifier {
  bool _isLoading = false;
  List<User> amigosProcurados = [];

  bool get loading => _isLoading;

  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteHistorico() async {
    amigosProcurados = [];
    final File fileId = await getFileId();
    fileId.delete();
    notifyListeners();
  }

  Future<File> getFileId() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/procurados.json");
  }

  Future<void> inserirAmigoNaLista({required User user}) async {
    if (!amigosProcurados.contains(user)) {
      amigosProcurados.remove(user);
      amigosProcurados.add(user);
      await saveAmigosProcurados();
      notifyListeners();
    } else {
      amigosProcurados.add(user);
      await saveAmigosProcurados();
      notifyListeners();
    }
  }

  Future<File> saveAmigosProcurados() async {
    final String data = jsonEncode(amigosProcurados);
    final file = await getFileId();
    return file.writeAsString(data);
  }

  Future<void> getAmigosProcurados() async {
    loading = true;
    try {
      final file = await getFileId();
      String jsonString = await file.readAsString();
      final decode = json.decode(jsonString);

      amigosProcurados = decode.map<User>(
        (user) {
          return User.fromMap(user as Map<String, dynamic>);
        },
      ).toList() as List<User>;
      loading = false;
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      loading = false;
    }
  }
}
