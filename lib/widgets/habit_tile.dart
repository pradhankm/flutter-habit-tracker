import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.isDoneToday,
    required this.onToggle,
    required this.onDelete,
  });

  final Habit habit;
  final bool isDoneToday;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(isDoneToday ? Icons.check_circle : Icons.circle_outlined),
        title: Text(habit.name),
        subtitle: Text('Goal/week: ${habit.goalPerWeek} • Streak: ${habit.streak}'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'toggle') onToggle();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(isDoneToday ? 'Mark not done' : 'Mark done'),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: onToggle,
      ),
    );
  }
}
