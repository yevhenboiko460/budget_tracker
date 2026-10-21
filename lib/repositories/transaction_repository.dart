import 'dart:convert';
import 'dart:io';

import 'package:budget_tracker/models/transaction.dart';

class TransactionRepository {
  final File _file;

  TransactionRepository({String filePath = 'transactions.json'})
    : _file = File(filePath);

  Future<List<Transaction>> load() async {
    if (!await _file.exists()) {
      return [];
    }

    final content = await _file.readAsString();
    if (content.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(content);

    if (decoded is! List) {
      throw const FormatException(
        'Transactions must be stored as a JSON array.',
      );
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each transaction must be a JSON object.');
      }

      return Transaction.fromJson(item);
    }).toList();
  }

  Future<void> save(List<Transaction> transactions) async {
    final data = transactions
        .map((transaction) => transaction.toJson())
        .toList();

    final content = jsonEncode(data);

    await _file.writeAsString(content);
  }
}
