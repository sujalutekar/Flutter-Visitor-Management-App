import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Center(
        child: TextField(
          // controller: widget.dateController,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: const Icon(Icons.calendar_month_outlined),
            hintText: formattedDate.isEmpty
                ? DateFormat('yMMMMd').format(DateTime.now())
                : null,
          ),
          readOnly: true,
          // onTap: () async {
          //   DateTime? pickedDate = await showDatePicker(
          //     context: context,
          //     initialDate: DateTime.now(),
          //     firstDate: DateTime.now(),
          //     lastDate: DateTime(2100),
          //   );

          //   if (pickedDate != null) {
          //     widget.onChange(pickedDate);
          //     setState(() {
          //       formattedDate = DateFormat('yMMMMd').format(pickedDate);
          //     });
          //     setState(() {
          //       widget.controller.text = formattedDate;
          //     });
          //   } else {}
          // },
        ),
      ),
    );
  }
}

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _timeOfDay =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeOfDay = TimeOfDay.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      setState(() {
        _timeOfDay = TimeOfDay.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Center(
        child: TextField(
          // controller: widget.timeController,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: const Icon(Icons.timelapse_outlined),
            hintText: _timeOfDay.format(context).toString(),
          ),
          readOnly: true,
          // onTap: () {
          //   showTimePicker(context: context, initialTime: TimeOfDay.now())
          //       .then((value) {
          //     setState(() {
          //       _timeOfDay = value!;
          //     });
          //   });
          // },
        ),
      ),
    );
  }
}
