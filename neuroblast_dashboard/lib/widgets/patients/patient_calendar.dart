import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PatientCalendar extends StatelessWidget {
  const PatientCalendar({super.key});

  // Generate 10 random dates before current date
  List<DateTime> _getRandomDates() {
    final now = DateTime.now();
    // Get the first day of the current month
    final startOfMonth = DateTime(now.year, now.month);
    final currentDay = now.day;
    final dates = <DateTime>[];
    final random = Random();

    // Create a set to avoid duplicate dates
    final selectedDays = <int>{};
    // Only select from days before today
    while (selectedDays.length < min(10, currentDay - 1)) {
      // Use min to handle early days of month
      final randomDay =
          random.nextInt(currentDay - 1) + 1; // +1 because nextInt starts at 0
      selectedDays.add(randomDay);
    }

    // Convert days to DateTime objects
    for (final day in selectedDays) {
      dates.add(DateTime(now.year, now.month, day));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final markedDates = _getRandomDates();

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarStyle: CalendarStyle(
        // Custom style for today's date
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        // Check if the current day is in the list of marked dates
        return markedDates.any(
          (date) =>
              date.year == day.year &&
              date.month == day.month &&
              date.day == day.day,
        )
            ? [1] // Return a non-empty list to indicate an event is present
            : [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            // If there is an event on this date, show a marker
            return Positioned(
              bottom: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null; // No marker if no event
        },
      ),
    );
  }
}
