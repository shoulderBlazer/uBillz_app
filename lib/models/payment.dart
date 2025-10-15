class Payment {
  final int? id;
  final String description;
  final double amount;
  final int day; // Day of the month (1-31)
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    this.id,
    required this.description,
    required this.amount,
    required this.day,
    this.isPaid = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Payment to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'day': day,
      'isPaid': isPaid ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Payment from Map (database retrieval)
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id']?.toInt(),
      description: map['description'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      day: map['day']?.toInt() ?? 1,
      isPaid: map['isPaid'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy of Payment with updated fields
  Payment copyWith({
    int? id,
    String? description,
    double? amount,
    int? day,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      day: day ?? this.day,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Payment{id: $id, description: $description, amount: $amount, day: $day, isPaid: $isPaid}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Payment &&
        other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.day == day &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        day.hashCode ^
        isPaid.hashCode;
  }
}
