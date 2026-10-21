enum TransactionType { income, expense }

class Transaction {
  final TransactionType type;
  final String category;
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type is! String) {
      throw const FormatException('Field "type" must be a string.');
    }

    final TransactionType parsedType;
    try {
      parsedType = TransactionType.values.byName(type);
    } on ArgumentError {
      throw FormatException('Unknown transaction type: "$type".');
    }

    final category = json['category'];
    if (category is! String) {
      throw const FormatException('Field "category" must be a string.');
    }

    final amount = json['amount'];
    if (amount is! num) {
      throw const FormatException('Field "amount" must be a number.');
    }

    final date = json['date'];
    if (date is! String) {
      throw const FormatException('Field "date" must be a string.');
    }

    final DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } on FormatException {
      throw FormatException('Field "date" is not a valid date: "$date".');
    }

    return Transaction(
      type: parsedType,
      category: category,
      amount: amount.toDouble(),
      date: parsedDate,
    );
  }
}
