import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Button/AddScheduleButton.dart';

class AdminIcon extends StatelessWidget {
  final Function onPressed;

  const AdminIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddScheduleDialog(); // AddScheduleDialog 호출
          },
        );
      },
    );
  }
}
