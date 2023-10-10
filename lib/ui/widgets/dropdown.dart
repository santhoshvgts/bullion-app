// ignore_for_file: unused_element, must_be_immutable

import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';
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

BorderRadius _borderRadius = BorderRadius.circular(6.0);

class DropdownField<T extends BaseModel> extends StatefulWidget {
  DropdownFieldController<T> controller;

  String title;
  String placeholder;
  EdgeInsets margin;
  EdgeInsets? padding;
  Function(T)? onChange;
  Function? onAddNewPressed;
  bool withAdd = false;
  bool showRequiredHint = true;

  DropdownField(this.title, this.controller,
      {Key? key,
      this.placeholder = "",
      this.margin = EdgeInsets.zero,
      this.padding,
      this.showRequiredHint = true,
      this.onChange})
      : super(key: key);

  DropdownField.withAdd(this.title, this.controller,
      {Key? key,
      this.placeholder = "",
      this.margin = EdgeInsets.zero,
      this.onChange,
      this.padding,
      this.showRequiredHint = true,
      this.onAddNewPressed})
      : super(key: key) {
    withAdd = true;
  }

  @override
  _DropdownFieldState<T> createState() => _DropdownFieldState<T>();
}

class _DropdownFieldState<T extends BaseModel> extends State<DropdownField<T>> {
  BorderRadius borderRadius = BorderRadius.circular(5);

  List<DropdownMenuItem<T>> get dropdownMenuItemWidget {
    return widget.controller.list.map<DropdownMenuItem<T>>((T value) {
      Map data = value.toJson();
      return DropdownMenuItem<T>(
        value: value,
        child: Text(
          data[widget.controller.valueId] ?? '',
          style: _bodyTextStyle,
        ),
      );
    }).toList();
  }

  T? emptyObject;

  @override
  void initState() {
    if (widget.withAdd) {
      Map<String, dynamic> map = {};
      map[widget.controller.keyId] = -1;
      map[widget.controller.valueId] = "Create New";
      BaseModel.createFromMap<T>(map).then((value) {
        setState(() {
          emptyObject = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: DropdownButtonFormField<T>(
        key: widget.controller.fieldKey,
        value: widget.controller.value,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColor.text,
        ),
        iconSize: 24,
        itemHeight: 48,
        validator: (value) {
          return widget.controller.validator(value);
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: widget.padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: false,
          border: _outlineInputBorder,
          enabledBorder: _outlineInputBorder,
          disabledBorder: _outlineInputBorder,
          focusedBorder: _focusedInputBorder,
          errorBorder: _errorInputBorder,
          errorMaxLines: 3,
          hintText: widget.placeholder,
          labelText: widget.title,
          errorStyle: _errorTextStyle,
          hintStyle: _hintTextStyle,
          focusColor: AppColor.secondary,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 15, maxHeight: 20),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 15, maxHeight: 20),
        ),
        style: _bodyTextStyle,
        isExpanded: true,
        focusNode: widget.controller.focusNode,
        selectedItemBuilder: (context) {
          if (widget.controller.value == null) {
            return [Container()];
          }

          Map? data = widget.controller.value?.toJson();
          if (data?[widget.controller.keyId] == -1) {
            return [Container()];
          }
          return List<Widget>.from(dropdownMenuItemWidget);
        },
        onChanged: (T? value) {
          if (value == null) return;

          if (value.toJson()[widget.controller.keyId] == -1) {
            setState(() {
              widget.controller.setValue(null);
            });
            return;
          }

          setState(() {
            widget.controller.setValue(value);
          });
          if (widget.onChange != null) {
            widget.onChange!(value);
          }
        },
        items: [
          ...dropdownMenuItemWidget,
          if (widget.withAdd && emptyObject != null)
            DropdownMenuItem<T>(
                value: emptyObject,
                onTap: () {
                  if (widget.onAddNewPressed != null) {
                    widget.onAddNewPressed!();
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                          child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      )),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    const Expanded(
                        child: Text(
                      "Create New",
                    )),
                  ],
                ))
        ],
      ),
    );
  }

  // InputDecoration decoration({ String? labelText }){
  //
  //   return ;
  //
  //   return InputDecoration(
  //       labelText: labelText,
  //       labelStyle: AppTextStyle.subHeading,
  //       floatingLabelStyle: AppTextStyle.bodyMediumSemiBold.copyWith(color: const Color(0xff263238), fontSize: 15),
  //       contentPadding: const EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
  //       focusedBorder: const OutlineInputBorder(
  //         borderSide: BorderSide(color: AppColor.primary, width: 1.5),
  //       ),
  //       border: OutlineInputBorder(
  //         borderSide: BorderSide(color: const Color(0xff263238).withOpacity(0.16), width: 1.0),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: const Color(0xff263238).withOpacity(0.16), width: 1.0),
  //       )
  //   );
  // }
}

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
