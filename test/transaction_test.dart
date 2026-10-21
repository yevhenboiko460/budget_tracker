import 'package:budget_tracker/models/transaction.dart';
import 'package:test/test.dart';

void main() {
  group('Transaction', () {
    test('toJson serializes all fields correctly', () {
      final transaction = Transaction(
        type: TransactionType.expense,
        category: 'Groceries',
        amount: 12.5,
        date: DateTime.parse('2026-01-15T10:30:00.000'),
      );

      final json = transaction.toJson();

      expect(json['type'], 'expense');
      expect(json['category'], 'Groceries');
      expect(json['amount'], 12.5);
      expect(json['date'], '2026-01-15T10:30:00.000');
    });

    test('fromJson restores a transaction from a map', () {
      final json = {
        'type': 'income',
        'category': 'Salary',
        'amount': 1000.0,
        'date': '2026-02-01T09:00:00.000',
      };

      final transaction = Transaction.fromJson(json);

      expect(transaction.type, TransactionType.income);
      expect(transaction.category, 'Salary');
      expect(transaction.amount, 1000.0);
      expect(transaction.date, DateTime.parse('2026-02-01T09:00:00.000'));
    });

    test('toJson then fromJson round-trips without data loss', () {
      final original = Transaction(
        type: TransactionType.income,
        category: 'Stocks',
        amount: 250.75,
        date: DateTime.parse('2026-03-10T14:00:00.000'),
      );

      final restored = Transaction.fromJson(original.toJson());

      expect(restored.type, original.type);
      expect(restored.category, original.category);
      expect(restored.amount, original.amount);
      expect(restored.date, original.date);
    });

    test('fromJson parses integer amount as double', () {
      final transaction = Transaction.fromJson({
        'type': 'expense',
        'category': 'Bills',
        'amount': 100,
        'date': '2026-04-01T00:00:00.000',
      });

      expect(transaction.amount, 100.0);
      expect(transaction.amount, isA<double>());
    });

    test('fromJson throws FormatException on unknown type', () {
      expect(
        () => Transaction.fromJson({
          'type': 'transfer',
          'category': 'Bills',
          'amount': 10,
          'date': '2026-04-01T00:00:00.000',
        }),
        throwsFormatException,
      );
    });

    test('fromJson throws FormatException on non-numeric amount', () {
      expect(
        () => Transaction.fromJson({
          'type': 'expense',
          'category': 'Bills',
          'amount': 'lots',
          'date': '2026-04-01T00:00:00.000',
        }),
        throwsFormatException,
      );
    });

    test('fromJson throws FormatException on invalid date', () {
      expect(
        () => Transaction.fromJson({
          'type': 'expense',
          'category': 'Bills',
          'amount': 10,
          'date': 'not-a-date',
        }),
        throwsFormatException,
      );
    });

    test('fromJson throws FormatException on missing/null field', () {
      expect(
        () => Transaction.fromJson({
          'type': 'expense',
          'category': 'Bills',
          'amount': 10,
          'date': null,
        }),
        throwsFormatException,
      );
    });
  });
}
