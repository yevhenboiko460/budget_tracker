# 💰 Budget Tracker

**A simple command-line application built with Dart.**

A small learning project for tracking personal income and expenses while exploring Dart fundamentals and asynchronous programming.

---

## ✨ Features

- 💵 **Income & Expenses** — add income and expense transactions.
- 🗂️ **Categories** — categorize transactions.
- 📋 **Transaction History** — view all recorded transactions.
- 📊 **Balance Overview** — calculate total income, expenses, and current balance.
- 💾 **Data Persistence** — save and load transactions using JSON.
- 🔄 **Stream Experiments** — explore Dart Streams and asynchronous event handling.
- ✅ **Input Validation** — handle invalid menu options and transaction amounts.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Dart | Core language |
| `dart:io` | Console input/output and file operations |
| `dart:convert` | JSON encoding and decoding |
| `Future` / `async` / `await` | Asynchronous operations |
| `Stream` | Working with asynchronous sequences |
| JSON | Transaction storage |

## 🚀 Getting Started

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart)

### Installation

Clone the repository and navigate to the project directory:

```bash
git clone <repository-url>
cd budget_tracker
```

Install dependencies:

```bash
dart pub get
```

### Run the Application

```bash
dart run
```

## 🧭 How It Works

After launching the application, use the console menu to choose an action:

| Option | Action |
|---|---|
| `1` | Add income |
| `2` | Add expense |
| `3` | Show transactions |
| `4` | Show balance |
| `5` | Test Stream