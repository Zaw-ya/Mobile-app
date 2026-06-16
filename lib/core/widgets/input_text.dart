import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dimensions/dimensions_constants.dart';
import 'title_text.dart';

class InputText extends StatefulWidget {
  final double? width;
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText, isPassword;
  final bool? enable;
  final bool? isError;
  final bool? isReadOnly;
  final String? suffixText;
  final bool isSearch;
  final int? maxLines;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const InputText._internal({
    this.title,
    this.width,
    this.controller,
    this.enable,
    this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.isError = false,
    this.isReadOnly = false,
    this.suffixText,
    this.onChanged,
    this.maxLines,
    this.inputFormatters,
    this.validator,
    this.onSaved,
    this.isSearch = false,
  });

  /// 🔹 Default Input
  factory InputText.normal({
    String? title,
    String? hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? suffixText,
    int? maxLines,
    bool enable = true,
    bool isError = false,
    double? width,
    Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
  }) {
    return InputText._internal(
      title: title,
      hint: hint,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      maxLines: maxLines,
      enable: enable,
      isError: isError,
      width: width,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      validator: validator,
      onSaved: onSaved,
    );
  }

  /// 🔹 Password Input
  factory InputText.password({
    String? title,
    String? hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    double? width,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
  }) {
    return InputText._internal(
      title: title,
      hint: hint,
      controller: controller,
      prefixIcon: prefixIcon,
      isPassword: true,
      obscureText: true,
      width: width,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
    );
  }

  /// 🔹 ReadOnly Input
  factory InputText.readOnly({
    String? title,
    String? hint,
    TextEditingController? controller,
    Widget? prefixIcon,
    double? width,
    String? Function(String?)? validator,
  }) {
    return InputText._internal(
      title: title,
      hint: hint,
      controller: controller,
      suffixIcon: prefixIcon,
      isReadOnly: true,
      enable: true,
      width: width,
      validator: validator,
    );
  }

  /// 🔹 Search Input
  factory InputText.search({
    String? title,
    String? hint,
    TextEditingController? controller,
    double? width,
    bool enable = true,
    bool isError = false,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
  }) {
    return InputText._internal(
      title: title,
      hint: hint ?? "Search...",
      controller: controller,
      keyboardType: TextInputType.text,
      prefixIcon: Icon(Icons.search, color: whiteTextColor, size: 24),
      enable: enable,
      isError: isError,
      width: width,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      isSearch: true,
    );
  }

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late final FocusNode _focusNode;
  bool _securePass = true;
  bool _hasValidationError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? width.w,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Row(
              children: [
                Expanded(
                  child: TitleText(
                    text: widget.title!,
                    fontSize: 16,
                    color: AppColor.gray700,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          if (widget.title != null) SizedBox(height: edge * 0.5),
          TextFormField(
            focusNode: _focusNode,
            cursorColor: widget.isSearch
                ? AppColor.whiteColor
                : AppColor.primaryColor,

            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            textInputAction: TextInputAction.search,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            controller: widget.controller,
            style: TextStyle(
              fontFamily: FontFamily.manchetteFine,
              color: widget.isSearch ? AppColor.whiteColor : AppColor.gray700,
            ),
            maxLines: widget.maxLines ?? 1,
            inputFormatters: widget.inputFormatters,
            obscureText: widget.isPassword ? _securePass : widget.obscureText,
            enabled: widget.enable ?? true,
            readOnly: widget.isReadOnly ?? false,
            textAlignVertical: TextAlignVertical.center,
            validator: (value) {
              final error = widget.validator?.call(value);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _hasValidationError = error != null;
                  });
                }
              });
              return error;
            },
            onSaved: widget.onSaved,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: (widget.maxLines ?? 0) > 1 ? edge * 0.5 : 0,
              ),
              prefixIcon: widget.prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: BorderSide(
                  color: widget.isSearch
                      ? Colors.transparent
                      : AppColor.gray300,
                  width: widget.isSearch ? 0 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: BorderSide(
                  color: widget.isSearch
                      ? Colors.transparent
                      : AppColor.primaryColor,
                  width: widget.isSearch ? 0 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: BorderSide(
                  color: widget.isSearch
                      ? Colors.transparent
                      : (widget.isError!
                            ? AppColor.primaryColor
                            : AppColor.gray300),
                  width: widget.isSearch ? 0 : 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: BorderSide(
                  color: widget.isSearch
                      ? Colors.transparent
                      : AppColor.primaryColor,
                  width: widget.isSearch ? 0 : 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: BorderSide(
                  color: widget.isSearch
                      ? Colors.transparent
                      : AppColor.gray300,
                  width: widget.isSearch ? 0 : 1,
                ),
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontFamily: FontFamily.manchetteFine,
                color: widget.isSearch
                    ? AppColor.whiteColor.withValues(alpha: 0.7)
                    : AppColor.gray300,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              fillColor: widget.isSearch
                  ? AppColor.whiteColor.withValues(alpha: 0.2)
                  : (widget.enable ?? true)
                  ? Colors.transparent
                  : AppColor.gray300,
              filled: true,
              suffixIconConstraints: widget.isReadOnly == true
                  ? const BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                      maxWidth: 35,
                      maxHeight: 35,
                    )
                  : null,

              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _securePass ? Icons.visibility : Icons.visibility_off,
                        color: (widget.isError == true || _hasValidationError)
                            ? AppColor.primaryColor
                            : _focusNode.hasFocus
                            ? AppColor.primaryColor
                            : AppColor.gray300,
                      ),
                      onPressed: _changeVisibility,
                    )
                  : (widget.suffixIcon ??
                        (widget.suffixText != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Center(
                                  widthFactor: 1.0,
                                  child: TitleText(
                                    text: widget.suffixText ?? "",
                                    color: AppColor.gray800,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : null)),
            ),
          ),
        ],
      ),
    );
  }

  void _changeVisibility() {
    setState(() {
      _securePass = !_securePass;
    });
  }
}
