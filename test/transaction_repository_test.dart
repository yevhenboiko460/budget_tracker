import 'dart:io';

import 'package:budget_tracker/models/transaction.dart';
import 'package:budget_tracker/repositories/transaction_repository.dart';
import 'package:test/test.dart';

void main() {
  group('TransactionRepository', () {
    late Directory tempDir;
    late String filePath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('budget_tracker_test');
      filePath = '${tempDir.path}/transactions.json';
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('load returns empty list when file does not exist', () async {
      final repository = TransactionRepository(filePath: filePath);

      final result = await repository.load();

      expect(result, isEmpty);
    });

    test('load returns empty list for an empty file', () async {
      await File(filePath).writeAsString('   ');
      final repository = TransactionRepository(filePath: filePath);

      final result = await repository.load();

      expect(result, isEmpty);
    });

    test('save then load round-trips transactions', () async {
      final repository = TransactionRepository(filePath: filePath);
      final transactions = [
        Transaction(
          type: TransactionType.income,
          category: 'Salary',
          amount: 2000.0,
          date: DateTime.parse('2026-01-01T08:00:00.000'),
        ),
        Transaction(
          type: TransactionType.expense,
          category: 'Groceries',
          amount: 55.5,
          date: DateTime.parse('2026-01-02T18:30:00.000'),
        ),
      ];

      await repository.save(transactions);
      final loaded = await repository.load();

      expect(loaded.length, 2);
      expect(loaded[0].category, 'Salary');
      expect(loaded[0].type, TransactionType.income);
      expect(loaded[1].category, 'Groceries');
      expect(loaded[1].amount, 55.5);
    });

    test('load throws FormatException when JSON is not an array', () async {
      await File(filePath).writeAsString('{"type": "income"}');
      final repository = TransactionRepository(filePath: filePath);

      expect(() => repository.load(), throwsFormatException);
    });

    test('load throws FormatException when JSON is invalid', () async {
      await File(filePath).writeAsString('not valid json');
      final repository = TransactionRepository(filePath: filePath);

      expect(() => repository.load(), throwsFormatException);
    });
  });
}
