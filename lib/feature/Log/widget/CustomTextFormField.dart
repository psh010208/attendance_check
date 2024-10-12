import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class InfoTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  InfoTextField({
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.obscureText = false,
    this.onSaved,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold, // 굵게
        color: Theme.of(context).hintColor,
        fontSize: 20.sp, // 반응형 폰트 크기
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold, // 굵게

          color: Theme.of(context).hintColor, // 라벨 색상 변경
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // 둥근 테두리

          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, // 테두리 색상
            width: 2.0.w, // 테두리 두께
          ),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
