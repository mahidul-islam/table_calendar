// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

class CalendarPage extends StatelessWidget {
  final Widget Function(BuildContext context, DateTime day)? dowBuilder;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;
  final List<DateTime> visibleDays;
  final Decoration? dowDecoration;
  final List<Decoration?>? monthDecoration;
  final Decoration? weekDecoration;
  final Decoration? defaultDecoration;
  final TableBorder? tableBorder;
  final bool dowVisible;

  const CalendarPage({
    Key? key,
    required this.visibleDays,
    this.dowBuilder,
    required this.dayBuilder,
    this.dowDecoration,
    this.monthDecoration,
    this.weekDecoration,
    this.defaultDecoration,
    this.tableBorder,
    this.dowVisible = true,
  })  : assert(!dowVisible || dowBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: tableBorder,
      children: [
        if (dowVisible) _buildDaysOfWeek(context),
        ..._buildCalendarDays(context),
      ],
    );
  }

  TableRow _buildDaysOfWeek(BuildContext context) {
    return TableRow(
      decoration: dowDecoration,
      children: List.generate(
        7,
        (index) => dowBuilder!(context, visibleDays[index]),
      ).toList(),
    );
  }

  List<TableRow> _buildCalendarDays(BuildContext context) {
    final rowAmount = visibleDays.length ~/ 7;

    return List.generate(rowAmount, (index) => index * 7).map(
      (index) {
        int rowNo = index ~/ 7;
        return TableRow(
          decoration: rowAmount == 1
              ? weekDecoration ?? defaultDecoration
              : ((monthDecoration?.length ?? 0) > rowNo)
                  ? monthDecoration![rowNo]
                  : defaultDecoration,
          children: List.generate(
            7,
            (id) => dayBuilder(context, visibleDays[index + id]),
          ),
        );
      },
    ).toList();
  }
}
