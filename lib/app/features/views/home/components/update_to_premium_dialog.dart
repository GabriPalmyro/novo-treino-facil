import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';
import 'package:tabela_treino/app/features/controllers/payments/payments_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';
import 'package:tabela_treino/app/shared/formatter.dart';

class UpdateToPremiumBottomSheet extends StatelessWidget {
  const UpdateToPremiumBottomSheet();
  static const errorMessage = 'Ocorreu um erro ao tentar comprar o plano premium. Tente novamente mais tarde.';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final premiumPrice = context.read<CoreAppController>().coreInfos.appPremiumPrice;
    return Container(
      height: height * 0.7,
      width: width * 0.9,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.2,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24.0),
            AutoSizeText(
              'Torne-se Premium!',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontFamily: AppFonts.gothamBold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            AutoSizeText(
              'Desbloqueie todos os recursos do aplicativo e leve seu treino ao próximo nível.',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontFamily: AppFonts.gothamLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 20.0),
            _buildFeatureList(),
            const Spacer(),
            AutoSizeText(
              'Tudo isso por apenas',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.gothamBook,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            AutoSizeText(
              MoneyFormatter.format(premiumPrice!),
              style: TextStyle(
                color: AppColors.mainColor,
                fontFamily: AppFonts.gothamBold,
                fontSize: 42,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            _buildUpgradeButton(context),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: FontAwesomeIcons.circleCheck,
          text: 'Criação ilimitada de planilhas de treino.',
        ),
        _buildFeatureItem(
          icon: FontAwesomeIcons.circleCheck,
          text: 'Criação ilimitada de exercícios personalizados.',
        ),
        _buildFeatureItem(
          icon: FontAwesomeIcons.circleCheck,
          text: 'Sem anúncios.',
        ),
        _buildFeatureItem(
          icon: FontAwesomeIcons.circleCheck,
          text: 'Suporte prioritário.',
        ),
        _buildFeatureItem(
          icon: FontAwesomeIcons.circleCheck,
          text: 'Geração infinita de planilhas com inteligência artificial.',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: AppColors.mainColor,
            size: 20,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: AutoSizeText(
              text,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: AppFonts.gotham,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final paymentsController = context.read<PaymentsController>();
          final productIds = {'premium_app'};

          if (!(await paymentsController.iap.isAvailable())) {
            log('In-app purchase is not available');
            Navigator.pop(context);
            mostrarSnackBar(message: errorMessage, color: AppColors.red, context: context);
            return;
          }

          final ProductDetailsResponse productDetails = await paymentsController.iap.queryProductDetails(productIds);

          if (productDetails.notFoundIDs.isNotEmpty) {
            log('Product not found: ${productDetails.notFoundIDs}');
            Navigator.pop(context);
            mostrarSnackBar(message: errorMessage, color: AppColors.red, context: context);
            return;
          }

          final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails.productDetails.first);
          await paymentsController.iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
        } catch (e) {
          log('Failed to buy plan: $e');
          Navigator.pop(context);
          mostrarSnackBar(message: errorMessage, color: AppColors.red, context: context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.0),
      ),
      child: Center(
        child: AutoSizeText(
          'Atualizar para Premium',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 18,
            fontFamily: AppFonts.gothamBold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
