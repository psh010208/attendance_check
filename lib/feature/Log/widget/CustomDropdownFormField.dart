import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 반응형 크기를 위해 ScreenUtil을 사용

class CustomDropdownFormField extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  CustomDropdownFormField({
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold, // 굵게
          fontSize: 19.sp, // 반응형 폰트 크기
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0, // 테두리 두께
          ),
        ),
      ),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
      items: items.map((item) {
        return DropdownMenuItem(
          child: Text(
            item,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold, // 굵게
              color: Theme.of(context).hintColor,
              fontSize: 18.sp, // 반응형 폰트 크기
            ),
          ),
          value: item,
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
