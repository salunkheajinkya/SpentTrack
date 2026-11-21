# SpendTrack – Personal Finance & Transaction Manager

SpendTrack is a personal finance management application built with Ruby on Rails. It helps users manage bank transactions, track income and expenses, monitor credit card spending, and understand their financial activities through a centralized dashboard.

The goal is to simplify personal finance management by consolidating transactions from multiple financial accounts into one place.

## 🚀 Project Goals

- Centralize transactions from multiple bank accounts and payment platforms.
- Track monthly income and expenses.
- Monitor spending patterns and financial activities.
- Manage credit card transactions and outstanding balances.
- Import historical bank and credit card statements.
- Automatically identify duplicate transactions.
- Provide meaningful financial insights through visual dashboards.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Ruby 3.3.6 | Programming language |
| Ruby on Rails 8.0.2 | Backend framework |
| PostgreSQL 14 | Database |
| Tailwind CSS | UI styling |
| Hotwire (Turbo & Stimulus) | Frontend interactions |
| Import Maps | JavaScript management |
| Redis | Caching and background jobs |
| Sidekiq | Background processing |
| Chart.js | Financial visualizations |

## ✨ Planned Features

### 1. Dashboard
- Total account balance
- Monthly income
- Monthly expenses
- Savings overview
- Recent transactions
- Spending breakdown by category

### 2. Transaction Management
- View all transactions in one place.
- Categorize income and expenses.
- Search and filter transactions.
- Track transfers between accounts.
- Edit and delete transactions.

### 3. Statement Import
- Upload multiple bank statements.
- Import SBI and HDFC statements.
- Import Google Pay and PhonePe transaction records.
- Import credit card statements.
- Parse transaction details automatically.
- Detect duplicate transactions.

### 4. Credit Card Management
- Manage multiple credit cards.
- Track outstanding balances.
- Monitor billing cycles.
- Track payments and expenses.

### 5. Financial Analytics
- Monthly income vs. expenses.
- Category-wise spending.
- Monthly spending trends.
- Savings analysis.

## 🏗️ Project Setup

### Prerequisites

- Ruby 3.3.6
- Rails 8.0.2
- PostgreSQL 14+
- Node.js
- Redis

### Clone the Repository

```bash
git clone https://github.com/salunkheajinkya/SpentTrack.git
cd SpentTrack
```

### Install Dependencies

```bash
bundle install
```

### Configure Database

Make sure PostgreSQL is running.

```bash
sudo systemctl start postgresql
```

Create the databases:

```bash
bin/rails db:create
bin/rails db:migrate
```

### Start the Development Server

```bash
bin/dev
```

Open your browser:

```text
http://localhost:3000
```

## 📁 Project Structure

```text
SpendTrack/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── javascript/
│   └── assets/
├── config/
├── db/
│   ├── migrate/
│   └── schema.rb
├── public/
├── test/
├── Gemfile
├── Gemfile.lock
└── README.md
```

## 🔐 Privacy & Security

- Designed as a private personal finance application.
- Financial statements are uploaded manually.
- No direct bank account connections are planned.
- Sensitive financial information must be protected.

## 🗺️ Development Roadmap

- [x] Initial Rails application setup
- [x] PostgreSQL integration
- [x] Ruby and Rails environment setup
- [ ] Dashboard UI
- [ ] User authentication
- [ ] Account management
- [ ] Transaction management
- [ ] Transaction categorization
- [ ] Statement upload system
- [ ] Automatic transaction parsing
- [ ] Duplicate transaction detection
- [ ] Credit card management
- [ ] Financial analytics
- [ ] Testing and deployment

## 📌 Project Status

**Currently under active development.**

New features and improvements will be added incrementally.

---

Built with ❤️ using Ruby on Rails.