//ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

import '../utils/Constants.dart';
import '../utils/Strings.dart';

class ThemedDropDown extends StatelessWidget {
  String? defaultValue;
  String? hintText;
  Widget? preFix;
  List<String> dataString = [];
  bool isDisabled = false;
  void Function(String) onChanged;
  bool isFromRepeating;
  void Function()? onTap;

  ThemedDropDown({
    super.key,
    required this.dataString,
    required this.onChanged,
    this.defaultValue,
    this.onTap,
    this.hintText,
    this.preFix,
    this.isDisabled = false,
    this.isFromRepeating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: boxBorderRadius,
      ),
      padding: const EdgeInsets.only(right: spaceHorizontal),
      child: Row(
        children: [
          if (preFix != null)
            Container(
              width: 47,
              height: 47,
              alignment: Alignment.center,
              child: Center(
                child: preFix,
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: DropdownButton(
                value: defaultValue,
                menuMaxHeight: 300,
                isExpanded: true,
                iconEnabledColor: colorPrimary.shade300,
                style:  TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colorPrimary.shade300,
                  fontFamily: stringFontFamilyGibson,
                  overflow: TextOverflow.ellipsis,
                ),
                borderRadius: boxBorderRadius,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: colorPrimary.shade300,
                ),
                underline: Container(),
                hint: Text(
                  hintText ?? "Select",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: stringFontFamilyGibson,
                    color: colorPrimary.shade300,
                  ),
                ),
                items: dataString
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.toString(),
                    child: Text(
                      e.toString(),
                      style: const TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: stringFontFamilyGibson,
                      ),
                    ),
                  ),
                )
                    .toList(growable: true),
                onChanged: !isFromRepeating && !isDisabled
                    ? (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemedTextField extends StatefulWidget {
  String? hintText;
  String? labelText;
  TextEditingController? controller;
  void Function()? onTap;
  bool isReadOnly = false;
  bool isAcceptNumbersOnly = false;
  bool isPasswordTextField = false;
  Widget? preFix;
  void Function(String)? onChanged;
  void Function(String)? onFieldSubmitted;
  FocusNode? currentFocusNode;
  FocusNode? nextFocusNode;
  FocusNode? previousFocusNode;
  Color? backgroundColor;
  Color? borderColor;
  TextInputType keyBoardType;
  Color textColor;
  Color hintTextColor;
  double fontSized;
  double hintFontSized;
  FontWeight fontWeight;
  FontWeight hintFontWeight;
  TextCapitalization? textCapitalization;
  String? Function(String?)? validator;
  double borderRadiusTextField;

  ThemedTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.isReadOnly = false,
    this.isPasswordTextField = false,
    this.isAcceptNumbersOnly = false,
    this.preFix,
    this.currentFocusNode,
    this.nextFocusNode,
    this.previousFocusNode,
    this.textCapitalization,
    this.backgroundColor,
    this.borderColor,
    this.keyBoardType = TextInputType.text,
    this.textColor = colorGrayText,
    this.hintTextColor = colorGrayLiteText,
    this.fontSized = 16,
    this.hintFontSized = 16,
    this.fontWeight = FontWeight.normal,
    this.hintFontWeight = FontWeight.normal,
    this.borderRadiusTextField = radius,
    this.validator,
  });

  @override
  State<ThemedTextField> createState() => _ThemedTextFieldState();
}

class _ThemedTextFieldState extends State<ThemedTextField> {
  bool isShowPassWord = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      focusNode: widget.currentFocusNode,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      inputFormatters: [
        if (widget.isAcceptNumbersOnly)
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      style: TextStyle(
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSized,
          color: widget.textColor,
          fontFamily: stringFontFamilyGibson),
      validator: widget.validator,
      keyboardType: widget.isAcceptNumbersOnly
          ? TextInputType.number
          : widget.keyBoardType,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        if (value.isEmpty && widget.previousFocusNode != null) {
          widget.previousFocusNode!.requestFocus();
        }
        setState(() {});
      },
      onFieldSubmitted: (value) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(value);
        }
        if (widget.nextFocusNode != null) {
          widget.nextFocusNode!.requestFocus();
        }
        setState(() {});
      },
      obscureText: isShowPassWord,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontWeight: widget.hintFontWeight,
            fontSize: widget.hintFontSized,
            color: widget.hintTextColor,
            fontFamily: stringFontFamilyGibson),
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: spaceHorizontal * 1.2, vertical: spaceVertical),
        filled: widget.backgroundColor != null ? true : false,
        fillColor: widget.backgroundColor ?? Colors.white,
        prefixIcon: widget.preFix != null
            ? SizedBox(
                height: 30, width: 30, child: Center(child: widget.preFix))
            : null,
        prefixIconColor: colorPrimary.shade100,
        suffixIcon: widget.isPasswordTextField
            ? InkWell(
                onTap: () {
                  setState(() {
                    isShowPassWord = !isShowPassWord;
                  });
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Icon(
                      isShowPassWord
                          ? CupertinoIcons.eye_solid
                          : CupertinoIcons.eye_slash_fill,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconColor: colorPrimary.shade100,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? colorPrimary.shade100,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? colorPrimary.shade100,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? colorPrimary.shade100,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? colorPrimary.shade300,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadiusTextField),
        ),
      ),
    );
  }
}
