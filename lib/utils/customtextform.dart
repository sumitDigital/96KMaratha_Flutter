import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.HintText,
    this.suffixIcon,
    this.textEditingController,
    this.validator,
    this.obscuretext = false,
    this.inputFormatters,
    this.readonly = false,
    this.ontap,
    this.onChange,
    this.textInputType,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });
  final bool obscuretext;
  final bool readonly;
  final String HintText;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;

  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? ontap;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Container(
        // height: 65,
        child: TextFormField(
          keyboardType: textInputType,
          autovalidateMode: autovalidateMode,
          readOnly: readonly,
          onTap: ontap,
          inputFormatters: inputFormatters ?? [],
          obscureText: obscuretext,
          controller: textEditingController,
          style: CustomTextStyle.bodytext,
          decoration: InputDecoration(
            errorMaxLines: 5,
            errorStyle: CustomTextStyle.errorText,
            labelStyle: CustomTextStyle.bodytext,
            hintText: HintText,
            contentPadding: const EdgeInsets.all(20),
            hintStyle: CustomTextStyle.hintText,
            filled: true,
            fillColor: Colors.white,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: suffixIcon,
          ),
          validator: validator,
          onChanged: onChange,
        ),
      ),
    );
  }
}
