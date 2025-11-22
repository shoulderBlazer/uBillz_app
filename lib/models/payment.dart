class Payment {
  final int? id;
  final String description;
  final double amount;
  final int day;
  final bool isPaid;
  final bool isDueToday;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    this.id,
    required this.description,
    required this.amount,
    required this.day,
    this.isPaid = false,
    this.isDueToday = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert a Payment into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'day': day,
      'isPaid': isPaid ? 1 : 0,
      'isDueToday': isDueToday ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a Payment from a Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int?,
      description: map['description'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      day: (map['day'] as num?)?.toInt() ?? 1,
      isPaid: map['isPaid'] == 1,
      isDueToday: map['isDueToday'] == 1,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'] as String) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'] as String) 
          : DateTime.now(),
    );
  }

  // Create a copy of the Payment with updated fields
  Payment copyWith({
    int? id,
    String? description,
    double? amount,
    int? day,
    bool? isPaid,
    bool? isDueToday,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      day: day ?? this.day,
      isPaid: isPaid ?? this.isPaid,
      isDueToday: isDueToday ?? this.isDueToday,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Payment{id: $id, description: $description, amount: $amount, day: $day, isPaid: $isPaid, isDueToday: $isDueToday}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Payment &&
        other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.day == day &&
        other.isPaid == isPaid &&
        other.isDueToday == isDueToday;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        day.hashCode ^
        isPaid.hashCode ^
        isDueToday.hashCode;
  }
}