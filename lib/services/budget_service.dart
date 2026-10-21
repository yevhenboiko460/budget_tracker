import 'package:budget_tracker/models/transaction.dart';

class BudgetService {
  const BudgetService();

  double totalIncome(List<Transaction> transactions) =>
      _sumByType(transactions, TransactionType.income);

  double totalExpense(List<Transaction> transactions) =>
      _sumByType(transactions, TransactionType.expense);

  double balance(List<Transaction> transactions) =>
      totalIncome(transactions) - totalExpense(transactions);

  double _sumByType(List<Transaction> transactions, TransactionType type) =>
      transactions
          .where((item) => item.type == type)
          .fold(0.0, (sum, item) => sum + item.amount);
}
