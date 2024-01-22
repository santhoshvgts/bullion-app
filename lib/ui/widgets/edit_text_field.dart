import 'dart:io';

import 'package:bullion/core/res/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../core/res/colors.dart';

TextStyle _errorTextStyle = AppTextStyle.bodySmall.copyWith(
  color: AppColor.error,
);
TextStyle _bodyTextStyle = AppTextStyle.bodyMedium;
TextStyle _hintTextStyle = AppTextStyle.bodyMedium.copyWith(
  color: const Color(0xff49454F).withOpacity(0.7),
  fontWeight: FontWeight.normal,
);

BorderRadius _borderRadius = BorderRadius.circular(4.0);

class EditTextField extends StatefulWidget {
  FormFieldController controller;

  String label;
  String? subTitle;
  TextStyle? textStyle;
  TextAlign textAlign;
  bool? readOnly = false;

  EdgeInsets? margin;
  EdgeInsets? padding;

  TextInputAction textInputAction;

  String? placeholder;
  Widget? prefixIcon;
  Widget? suffixIcon;

  String? prefixText;
  String? counterText;

  bool autoFocus = false;
  bool isPasswordField = false;

  bool enabled = true;
  bool isInputDecorationNone = false;

  ValueChanged<String>? onChanged = (terms) {};
  ValueChanged<String>? onSubmitted = (terms) {};

  EditTextField(this.label, this.controller,
      {Key? key,
      this.margin = EdgeInsets.zero,
      this.onSubmitted,
      this.onChanged,
      this.subTitle,
      this.readOnly = false,
      this.autoFocus = false,
      this.enabled = true,
      this.prefixText,
      this.placeholder,
      this.prefixIcon,
      this.padding,
      this.textAlign = TextAlign.left,
      this.textStyle,
      this.textInputAction = TextInputAction.next,
      this.suffixIcon,
      this.isInputDecorationNone = false,
      this.counterText})
      : super(key: key);

  EditTextField.password(this.label, this.controller,
      {Key? key,
      this.margin = EdgeInsets.zero,
      this.onSubmitted,
      this.onChanged,
      this.enabled = true,
      this.autoFocus = false,
      this.prefixText,
      this.placeholder,
      this.prefixIcon,
      this.padding,
      this.textAlign = TextAlign.left,
      this.textInputAction = TextInputAction.next,
      this.suffixIcon})
      : super(key: key) {
    isPasswordField = true;
  }

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool isVisible = false;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
  }

  TextInputType get keyboardType {
    if ((widget.controller.textInputType == TextInputType.number ||
            widget.controller.textInputType ==
                const TextInputType.numberWithOptions(decimal: true)) &&
        Platform.isIOS) {
      return const TextInputType.numberWithOptions(decimal: true, signed: true);
    }
    return widget.controller.textInputType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: FormField<String>(
        initialValue: widget.controller.text,
        validator: (value) {
          if (!widget.controller.required && widget.controller.text.isEmpty) {
            return null;
          }

          if ((widget.controller.required ||
                  widget.controller.text.isNotEmpty) &&
              widget.controller.validator != null) {
            return widget.controller.validator!(value);
          }

          return null;
        },
        builder: (FormFieldState state) {
          // ignore: invalid_use_of_protected_member
          if (widget.controller.textEditingController.hasListeners) {
            widget.controller.textEditingController.removeListener(() {});
          }

          widget.controller.textEditingController.addListener(() {
            if(mounted) {
              state.reset();
              state.didChange(widget.controller.text);
            }
          });

          return TextField(
            key: widget.controller.fieldKey,
            readOnly: widget.readOnly ?? false,
            controller: widget.controller.textEditingController,
            obscureText: widget.isPasswordField && !isVisible ? true : false,
            textInputAction: widget.textInputAction,
            textAlign: widget.textAlign,
            style: widget.textStyle ??
                _bodyTextStyle.copyWith(
                  color: !widget.enabled ? const Color(0xff8C8C8D) : null,
                ),
            focusNode: widget.controller.focusNode,
            autofocus: widget.autoFocus,
            cursorColor: AppColor.text,
            cursorWidth: 1.5,
            onChanged: (value) {
              state.reset();
              state.didChange(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onSubmitted: (value) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(value);
              }
            },
            enabled: widget.enabled,
            maxLength: widget.controller.maxLength,
            maxLines: widget.isPasswordField ? 1 : widget.controller.maxLines,
            minLines: widget.controller.minLines,
            inputFormatters: widget.isPasswordField ||
                    widget.controller.textInputType ==
                        TextInputType.emailAddress
                ? [FilteringTextInputFormatter.deny(RegExp('[\\ ]'))]
                : widget.controller.inputFormatter,
            decoration: InputDecoration(
              fillColor: !widget.enabled ? AppColor.secondaryBackground : Colors.white,
              filled: true,
              contentPadding: widget.padding ??
                  const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
              alignLabelWithHint: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: widget.isInputDecorationNone ? noBorder : _outlineInputBorder,
              enabledBorder: widget.isInputDecorationNone ? noBorder  : _outlineInputBorder,
              disabledBorder: widget.isInputDecorationNone ? noBorder : _outlineInputBorder,
              focusedBorder: widget.isInputDecorationNone ? noBorder : _focusedInputBorder,
              errorBorder: widget.isInputDecorationNone ? noBorder : _errorInputBorder,
              errorText: state.hasError
                  ? state.errorText
                  : widget.controller.overrideErrorText,
              errorMaxLines: 3,
              hintText: widget.placeholder,
              labelText: widget.label,
              errorStyle: _errorTextStyle,
              hintStyle: _hintTextStyle,
              focusColor: AppColor.error,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 15,
                maxHeight: 20,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 15,
                maxHeight: 20,
              ),
              prefix: widget.prefixText == null
                  ? null
                  : Text(
                      "${widget.prefixText} ",
                      style: _bodyTextStyle,
                    ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPasswordField
                  ? _buildPasswordEyeIcon()
                  : widget.suffixIcon,
              counterText: widget.counterText ?? "",
            ),
            keyboardType: keyboardType,
            textCapitalization: widget.controller.textCapitalization,
          );
        },
      ),
    );
  }

  Widget _buildPasswordEyeIcon() {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          isVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
          size: 20,
        ),
        onPressed: () {
          isVisible = !isVisible;
          setState(() {});
        });
  }

  void dispose() {
    super.dispose();
  }
}

InputBorder noBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent)
);

InputBorder _outlineInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: Color(0xff79747E),
    width: 0.5,
  ),
);

InputBorder _focusedInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: AppColor.primary,
    width: 1,
  ),
);

InputBorder _errorInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: AppColor.error,
    width: 1,
  ),
);
