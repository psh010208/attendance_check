import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator; // validator 추가

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
      style: Theme
          .of(context)
          .textTheme
          .titleSmall
          ?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme
            .of(context)
            .hintColor,
        fontSize: 20.sp, // 반응형 폰트 크기
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme
            .of(context)
            .colorScheme
            .background
            .withOpacity(0.1),
        // 배경색 설정
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme
              .of(context)
              .hintColor,
          fontSize: 18.sp, // 라벨 폰트 크기
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // 라벨이 항상 위에 고정되도록 설정
        prefixIcon: Icon(
          Icons.person, // 원하는 아이콘으로 변경 가능
          color: Theme
              .of(context)
              .colorScheme
              .primary
              .withOpacity(0.7),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        // 내용 여백 추가
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .primary
                .withOpacity(0.5), // 비활성 상태 테두리 색상
            width: 1.5.w, // 반응형 테두리 두께
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .primary, // 포커스 상태 테두리 색상
            width: 2.0.w, // 포커스 상태 테두리 두께
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Colors.redAccent, // 에러 상태 테두리 색상
            width: 1.5.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Colors.redAccent, // 포커스된 에러 상태 테두리 색상
            width: 2.0.w,
          ),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator, // TextFormField에 validator 추가
    );
  }
}