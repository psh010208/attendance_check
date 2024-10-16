import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'Schedule_card.dart';
import 'Schedule_card_info.dart';

class DraggableCard extends StatefulWidget {
  final Schedule schedule;
  final int index;
  final List<bool> isExpandedList;
  final Function(List<bool>) onExpansionChanged;

  const DraggableCard({
    Key? key,
    required this.schedule,
    required this.index,
    required this.isExpandedList,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        updateExpansionState(details);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          top: widget.isExpandedList[widget.index] ? 200.0 * widget.index : 40.0 * widget.index,
        ),
        child: Column(
          children: [
            ScheduleCardDesign(schedule: widget.schedule),
            ScheduleCardInfo(schedule: widget.schedule),
          ],
        ),
      ),
    );
  }

  void updateExpansionState(DragUpdateDetails details) {
    if (widget.isExpandedList.every((isExpanded) => isExpanded)) {
      if (details.delta.dy < -10 && widget.index == widget.isExpandedList.length - 1) {
        widget.onExpansionChanged(List.filled(widget.isExpandedList.length, false)); // 카드 접기
      }
    } else {
      if (details.delta.dy > 10) {
        widget.onExpansionChanged(List.filled(widget.isExpandedList.length, true)); // 카드 펼치기
      }
    }
  }
}
