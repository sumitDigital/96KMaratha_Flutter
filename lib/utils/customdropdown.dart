import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.suffixIcon,
  });

  final List<FieldModel> items; // The list of FieldModel
  final FieldModel? value; // The selected FieldModel
  final void Function(FieldModel?)? onChanged;
  final String hintText;
  final String? Function(FieldModel?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: SizedBox(
        child: DropdownButtonFormField<FieldModel>(
          style: CustomTextStyle.bodytext,
          iconEnabledColor: Colors.grey.shade500,
          iconDisabledColor: Colors.grey.shade500,
          dropdownColor: Colors.white,

          value: value, // The currently selected value
          onChanged: onChanged, // Triggered when the value changes
          decoration: InputDecoration(
            hintStyle: CustomTextStyle.hintText,
            contentPadding: const EdgeInsets.all(18),
            filled: true,
            fillColor: Colors.white,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
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
          hint: Text(
            overflow: TextOverflow.ellipsis,
            hintText,
            style: CustomTextStyle.hintText,
          ),
          validator: validator,
          items: items
              .map((item) => DropdownMenuItem<FieldModel>(
                    value: item,
                    child: Text(item.name ?? ""),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
