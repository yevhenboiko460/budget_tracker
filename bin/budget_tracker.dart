import 'dart:io';

import 'package:budget_tracker/categories.dart';
import 'package:budget_tracker/models/transaction.dart';
import 'package:budget_tracker/repositories/transaction_repository.dart';
import 'package:budget_tracker/services/budget_service.dart';

void main(List<String> arguments) async {
  final repository = TransactionRepository();

  late final List<Transaction> transactions;

  try {
    transactions = await repository.load();
    print('Loaded ${transactions.length} transactions.');
  } on FormatException catch (error) {
    print('Cannot read transactions: invalid JSON.');
    print(error);
    return;
  } on FileSystemException catch (error) {
    print('Cannot access transactions file.');
    print(error);
    return;
  } on TypeError catch (error) {
    print('Transactions file has an unexpected structure.');
    print(error);
    return;
  } on ArgumentError catch (error) {
    print('Transactions file has an invalid value.');
    print(error);
    return;
  } on NoSuchMethodError catch (error) {
    print('Transactions file has an unexpected structure.');
    print(error);
    return;
  }

  print('=========================');
  print('WELCOME TO BUDGET TRACKER');
  print('=========================');
  print('1. Add income');
  print('2. Add expense');
  print('3. Show transactions');
  print('4. Show balance');
  print('5. Stream test');
  print('6. Exit');

  stdout.write('Choose an option: ');
  final String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await addTransaction(
        type: TransactionType.income,
        categories: incomeCategories,
        transactions: transactions,
        repository: repository,
      );
    case '2':
      await addTransaction(
        type: TransactionType.expense,
        categories: expenseCategories,
        transactions: transactions,
        repository: repository,
      );
    case '3':
      showTransactions(transactions: transactions);
    case '4':
      showBalance(transactions: transactions);
    case '5':
      await testStream();
    case '6':
      print('Goodbye!');
    default:
      print('Unknown option!');
  }
}

void showBalance({required List<Transaction> transactions}) {
  clearConsole();
  const service = BudgetService();

  print('Total Income: ${service.totalIncome(transactions)}');
  print('Total Expense: ${service.totalExpense(transactions)}');
  print('Balance: ${service.balance(transactions)}');
}

void showTransactions({required List<Transaction> transactions}) {
  clearConsole();
  if (transactions.isEmpty) {
    print('No transactions yet');
    return;
  }

  for (var i = 0; i < transactions.length; i++) {
    final item = transactions[i];
    print(
      '${i + 1}. ${item.type.name} | ${item.category} | ${item.amount} | ${item.date} |',
    );
  }
}

Future<void> addTransaction({
  required TransactionType type,
  required List<String> categories,
  required List<Transaction> transactions,
  required TransactionRepository repository,
  String? initMessage,
}) async {
  clearConsole();
  if (initMessage != null) {
    print(initMessage);
  }
  print('Select ${type.name} category');

  printNormalizedCategories(categories: categories);

  final category = getSelectedCategory(categories: categories);
  final amount = getTransactionAmount();

  final transaction = Transaction(
    type: type,
    category: category,
    amount: amount,
    date: DateTime.now(),
  );

  transactions.add(transaction);

  try {
    await repository.save(transactions);
    print('Transaction saved successfully!');
    print('Type: ${transaction.type.name}');
    print('Category: ${transaction.category}');
    print('Amount: ${transaction.amount}');
    print('Date: ${transaction.date}');
  } on FileSystemException catch (error) {
    print('Failed to save transaction.');
    print(error);
  }
}

void printNormalizedCategories({required List<String> categories}) {
  for (var i = 0; i < categories.length; i++) {
    print('${i + 1}. ${categories[i]}');
  }
}

String getSelectedCategory({required List<String> categories}) {
  while (true) {
    stdout.write('Choose option: ');
    final String? choice = stdin.readLineSync();

    if (choice == null) {
      print('\nNo input. Exiting.');
      exit(0);
    }

    final categoryNumber = int.tryParse(choice);

    if (categoryNumber != null &&
        categoryNumber >= 1 &&
        categoryNumber <= categories.length) {
      return categories[categoryNumber - 1];
    }

    print('Wrong option! Try again');
  }
}

double getTransactionAmount() {
  while (true) {
    stdout.write('Add amount: ');

    final String? input = stdin.readLineSync();

    if (input == null) {
      print('\nNo input. Exiting.');
      exit(0);
    }

    final double? amount = double.tryParse(input);

    if (amount != null && amount > 0) {
      return amount;
    }

    print('Invalid amount! Enter a positive number.');
  }
}

void clearConsole() {
  print('\x1B[2J\x1B[H');
}

Future<void> testStream() async {
  Stream<double> expenseStream() async* {
    yield 12.5;
    yield 30.0;
    yield 7.99;
  }

  print('\nStarting stream test...');

  await for (final expense in expenseStream()) {
    print('Expense: $expense');
  }

  print('Stream completed!');
}
