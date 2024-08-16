import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';

class PaymentsController extends ChangeNotifier {
  // Private constructor
  PaymentsController(
    this.userManager,
  ) {
    initialize();
  }

  final UserManager userManager;

  // Create a private variable
  final InAppPurchase _iap = InAppPurchase.instance;

  InAppPurchase get iap => _iap;

  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  @override
  void dispose() {
    _purchasesSubscription.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    if (!(await _iap.isAvailable())) return;

    ///catch all purchase updates
    _purchasesSubscription = _iap.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _purchasesSubscription.cancel();
      },
      onError: (error) {},
    );
  }

  // Add your methods related to in-app purchases here
  handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (int index = 0; index < purchaseDetailsList.length; index++) {
      var purchaseStatus = purchaseDetailsList[index].status;
      switch (purchaseDetailsList[index].status) {
        case PurchaseStatus.pending:
          log(' purchase is in pending ');
          continue;
        case PurchaseStatus.error:
          log(' purchase error ');
          break;
        case PurchaseStatus.canceled:
          log(' purchase cancel ');
          break;
        case PurchaseStatus.purchased:
          log(' purchased ');
          break;
        case PurchaseStatus.restored:
          log(' purchase restore ');
          break;
      }

      if (purchaseDetailsList[index].pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetailsList[index]).then((value) {
          if (purchaseStatus == PurchaseStatus.purchased) {
            userManager.updateUserPremiumStatus(true);
          }
        });
      }
    }
  }
}
