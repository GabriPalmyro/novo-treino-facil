import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tabela_treino/firebase_options.dart';

import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(MobileAds.instance.initialize());

  await dotenv.load();

  final sentryDns = dotenv.env['SENTRY_DSN'] ?? '';

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDns;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.enableAutoNativeBreadcrumbs = true;
    },
    appRunner: () => runApp(MyApp()),
  );
}
