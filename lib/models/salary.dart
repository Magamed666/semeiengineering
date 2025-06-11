class Salary {
  final String id;
  final String date;
  final double amount;
  final String employeeName; // 👈 Добавлено

  Salary({
    required this.id,
    required this.date,
    required this.amount,
    required this.employeeName, // 👈 Добавлено
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      employeeName: json['employee_name'], // 👈 Убедись, что это имя поля в JSON
    );
  }
}
