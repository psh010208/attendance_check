import 'package:flutter/material.dart';

class InfoModel{
  static String? role; // 역할을 저장하는 정적 변수
  static String? id;   // ID를 저장하는 정적 변수

  // 정보를 설정하는 메서드
  static void setUser(String newRole, String newId) {
    role = newRole;
    id = newId;
  }
}
