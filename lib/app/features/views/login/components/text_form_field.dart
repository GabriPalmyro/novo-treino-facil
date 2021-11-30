import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tabela_treino/app/core/app_fonts.dart';
import 'package:tabela_treino/app/core/core.dart';

class LoginTextFormField extends StatefulWidget {
  final TextInputType textInputType;
  final TextEditingController textController;
  final Color textColor;
  final Color labelColor;
  final String labelText;
  final Function(String) validator;
  final List<TextInputFormatter> inputFormatters;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool isObscure;
  final bool enable;
  final double width;

  const LoginTextFormField(
      {this.textInputType,
      this.textController,
      this.textColor,
      this.labelColor,
      this.labelText,
      this.isObscure = false,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.inputFormatters,
      this.enable,
      this.width});

  @override
  _LoginTextFormFieldState createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
          color: AppColors.lightGrey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          keyboardType: widget.textInputType,
          controller: widget.textController,
          obscureText: widget.isObscure,
          enabled: widget.enable,
          style: TextStyle(
              fontFamily: AppFonts.gotham,
              color: widget.textColor,
              fontSize: 16.0),
          showCursor: true,
          enableInteractiveSelection: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorStyle:
                TextStyle(fontFamily: AppFonts.gotham, color: AppColors.red),
            labelText: widget.labelText,
            labelStyle: TextStyle(
                fontFamily: AppFonts.gotham, color: widget.labelColor),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          inputFormatters: widget.inputFormatters,
          validator: widget.validator),
    );
  }
}
