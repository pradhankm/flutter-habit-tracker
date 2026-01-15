class Habit {
  Habit({
    required this.id,
    required this.name,
    this.goalPerWeek = 5,
    required this.completedDates, // yyyy-mm-dd strings
    this.streak = 0,
  });

  final String id;
  String name;
  int goalPerWeek;
  List<String> completedDates;
  int streak;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'goalPerWeek': goalPerWeek,
        'completedDates': completedDates,
        'streak': streak,
      };

  static Habit fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        goalPerWeek: (json['goalPerWeek'] as num?)?.toInt() ?? 5,
        completedDates:
            (json['completedDates'] as List<dynamic>? ?? []).cast<String>(),
        streak: (json['streak'] as num?)?.toInt() ?? 0,
      );
}
