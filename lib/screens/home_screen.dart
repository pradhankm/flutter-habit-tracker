import 'dart:math';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../storage/habit_store.dart';
import '../utils/date_utils.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = HabitStore();
  final _rng = Random.secure();

  List<Habit> _habits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final habits = await _store.loadHabits();
    final now = DateTime.now();
    for (final h in habits) {
      h.streak = computeStreak(h.completedDates, now);
    }
    setState(() {
      _habits = habits;
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await _store.saveHabits(_habits);
  }

  String _newId() => 'h_${_rng.nextInt(1 << 31)}';

  Future<void> _addHabit() async {
    final nameController = TextEditingController();
    final goalController = TextEditingController(text: '5');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(labelText: 'Goal per week (1-7)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final name = nameController.text.trim();
    if (name.isEmpty) return;

    int goal = int.tryParse(goalController.text.trim()) ?? 5;
    goal = goal.clamp(1, 7);

    final habit = Habit(
      id: _newId(),
      name: name,
      goalPerWeek: goal,
      completedDates: [],
      streak: 0,
    );

    setState(() => _habits = [..._habits, habit]);
    await _persist();
  }

  Future<void> _toggleDone(Habit habit) async {
    final now = DateTime.now();
    final k = todayKey(now);
    final set = habit.completedDates.toSet();

    if (set.contains(k)) {
      habit.completedDates.remove(k);
    } else {
      habit.completedDates.add(k);
    }

    habit.streak = computeStreak(habit.completedDates, now);
    setState(() {});
    await _persist();
  }

  Future<void> _deleteHabit(Habit habit) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('Remove "${habit.name}" permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _habits = _habits.where((h) => h.id != habit.id).toList());
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = todayKey(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.track_changes, size: 48),
                        SizedBox(height: 12),
                        Text('Add your first habit to get started.'),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text('Today: $today', style: Theme.of(context).textTheme.labelLarge),
                    ),
                    ..._habits.map((h) {
                      final isDone = h.completedDates.contains(today);
                      return HabitTile(
                        habit: h,
                        isDoneToday: isDone,
                        onToggle: () => _toggleDone(h),
                        onDelete: () => _deleteHabit(h),
                      );
                    }),
                    const SizedBox(height: 80),
                  ],
                ),
    );
  }
}
