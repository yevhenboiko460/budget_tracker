import 'package:budget_tracker/models/transaction.dart';
import 'package:budget_tracker/services/budget_service.dart';
import 'package:test/test.dart';

void main() {
  const service = BudgetService();

  Transaction income(double amount) => Transaction(
    type: TransactionType.income,
    category: 'Salary',
    amount: amount,
    date: DateTime(2026, 1, 1),
  );

  Transaction expense(double amount) => Transaction(
    type: TransactionType.expense,
    category: 'Groceries',
    amount: amount,
    date: DateTime(2026, 1, 1),
  );

  group('BudgetService', () {
    test('totals are zero for an empty list', () {
      expect(service.totalIncome([]), 0.0);
      expect(service.totalExpense([]), 0.0);
      expect(service.balance([]), 0.0);
    });

    test('totalIncome sums only income transactions', () {
      final transactions = [income(100), income(50), expense(30)];
      expect(service.totalIncome(transactions), 150.0);
    });

    test('totalExpense sums only expense transactions', () {
      final transactions = [income(100), expense(30), expense(20)];
      expect(service.totalExpense(transactions), 50.0);
    });

    test('balance is income minus expense', () {
      final transactions = [income(200), expense(75), expense(25)];
      expect(service.balance(transactions), 100.0);
    });

    test('balance can be negative', () {
      final transactions = [income(50), expense(80)];
      expect(service.balance(transactions), -30.0);
    });
  });
}
