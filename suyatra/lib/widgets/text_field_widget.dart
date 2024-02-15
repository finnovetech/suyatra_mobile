import 'package:flutter/material.dart';
import 'package:suyatra/constants/font_sizes.dart';

import '../constants/app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool autoFocus;
  final TextEditingController? controller;
  final bool isPasswordField;
  final List<String>? autoFillHints;
  final Widget? suffixIcon;
  final String? textValue;
  final bool readOnly;
  final void Function(String?)? onChanged;
  const TextFieldWidget({
    Key? key, 
    this.labelText, 
    this.hintText, 
    this.autoFocus = false, 
    this.controller, 
    this.isPasswordField = false, 
    this.autoFillHints, 
    this.suffixIcon,
    this.textValue,
    this.readOnly = false,
    this.onChanged,
  }) : super(key: key);

  @override
  TextFieldDesignPageState createState() => TextFieldDesignPageState();
}

class TextFieldDesignPageState extends State<TextFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  Color _borderColor = grey300;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  changePasswordObscure() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.autoFocus) {
      _focusNode.requestFocus();
    }
    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus ? blackColor : grey300;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        color: grey300,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        onChanged: widget.onChanged,
        readOnly: widget.readOnly,
        autofillHints: widget.isPasswordField ? [
          AutofillHints.password,
        ] : widget.autoFillHints,
        focusNode: _focusNode,
        controller: widget.controller ?? TextEditingController(text: widget.textValue ?? ""),
        obscureText: widget.isPasswordField ? _obscurePassword : false,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          floatingLabelStyle: const TextStyle(
            fontSize: h11,
            color: grey500,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: const TextStyle(
            fontSize: h9,
            color: grey500,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: h9,
            color: grey500,
          ),
          labelText: widget.labelText,
          suffixIconConstraints: const BoxConstraints(),
          suffixIcon: widget.suffixIcon ?? (widget.isPasswordField 
            ? InkWell(
              onTap: () {
                changePasswordObscure();
              },
              child: Icon(
                  !obscurePassword 
                    ? Icons.visibility_sharp
                    : Icons.visibility_off_outlined,
                  color: blackColor,
                ),
            )
            : null),
        ),
      ),
    );
  }
}