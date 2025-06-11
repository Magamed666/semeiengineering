class Salary {
  final String id;
  final String date;
  final double amount;

  Salary({required this.id, required this.date, required this.amount});

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'],
      date: json['date'],
      amount: json['amount'].toDouble(),
    );
  }
}
