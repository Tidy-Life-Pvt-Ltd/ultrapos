import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final AutovalidateMode? autovalidateMode;
  final bool autocorrect;
  final bool enabled;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final String hintText;
  final String labelText;
  final String? counterText;
  final String? errorText;
  final String? Function(String?)? validator;
  final String? helperText;
  final String? initialValue;
  final String? prefixText;
  final String? suffixText;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool hasBorder;
  final TextInputFormatter? inputFormatters;
  final TextEditingController? controller;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextStyle? labelStyle;
  final GestureTapCallback? onTap;

  final FocusNode focusNode;

  const CustomTextForm({
    super.key,
    required this.hintText,
    required this.labelText,
    this.autocorrect = true,
    this.autovalidateMode,
    this.counterText,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.initialValue,
    this.keyboardType,
    this.maxLength,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.prefixText,
    this.readOnly = false,
    this.suffixIcon,
    this.suffixText,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.hasBorder = true,
    this.inputFormatters,
    this.controller,
    this.onTapOutside,
    this.labelStyle,
    this.onTap,
    required this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Padding(
         // padding: const EdgeInsets.symmetric(horizontal: 38),
          TextFormField(
            onTap: onTap,
            onTapOutside: onTapOutside,
            controller: controller,
            inputFormatters: inputFormatters != null ? [inputFormatters!] : null,
            autocorrect: autocorrect,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            initialValue: initialValue,
            keyboardType: keyboardType,
            maxLength: maxLength,
            obscureText: obscureText,
            onChanged: onChanged,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
            validator: validator,
            focusNode: focusNode,
            decoration: InputDecoration(
              counterText: counterText,
              errorText: errorText,
              helperText: helperText,
              hintText: hintText,
              labelText: labelText,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              suffixIcon: suffixIcon,
              suffixText: suffixText,
              labelStyle: labelStyle,

            ),
          ),
        //),
        // if (hasBorder) const Divider(),
      ],
    );
  }
}
