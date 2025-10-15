# uBillz

A Flutter mobile app version of uBillz that works completely offline, storing all data locally on the user's device.

## Features

- **Offline-First Architecture** - All data stored locally using SQLite
- **Secure Authentication** - PIN and biometric authentication
- **Payment Management** - Add, edit, delete, and view payments
- **Dashboard Overview** - Personalized greeting and payment summaries
- **Monthly Budget Tracking** - Track total payments and remaining budget
- **Modern UI** - Dark theme with teal/purple gradients matching uBillz design

## Screenshots

The app replicates the core functionality of the uBillz web app:
- Dashboard with personalized greeting and payment totals
- Upcoming payments list with day, amount, and description
- Add payment form with validation
- Full payments list with edit/delete actions

## Tech Stack

- **Flutter** - Cross-platform mobile development
- **SQLite** - Local database storage
- **Provider** - State management
- **Local Auth** - Biometric and PIN authentication
- **Secure Storage** - Encrypted storage for sensitive data

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode for device testing

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### First Time Setup

1. Launch the app
2. Enter your name and create a 4-digit PIN
3. Start adding your payments!

## Architecture

### Data Model
- **Payment**: Contains description, amount, day, and timestamps
- **SQLite Database**: Local storage with full CRUD operations
- **Provider Pattern**: State management for reactive UI updates

### Authentication
- **PIN Authentication**: 4-digit PIN stored securely
- **Biometric Authentication**: Fingerprint/Face ID support
- **Secure Storage**: Encrypted storage for authentication data

### Offline Capabilities
- **No Server Dependency**: All data stored locally
- **Instant Access**: No network required for any functionality
- **Data Persistence**: SQLite ensures data survives app restarts

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── payment.dart         # Payment data model
├── providers/
│   ├── auth_provider.dart   # Authentication state management
│   └── payment_provider.dart # Payment data management
├── screens/
│   ├── splash_screen.dart   # App initialization
│   ├── auth/
│   │   ├── setup_screen.dart    # First-time setup
│   │   └── login_screen.dart    # Authentication
│   ├── home/
│   │   └── dashboard_screen.dart # Main dashboard
│   └── payments/
│       ├── add_payment_screen.dart
│       ├── edit_payment_screen.dart
│       └── payments_list_screen.dart
├── services/
│   └── database_helper.dart # SQLite operations
└── utils/
    └── theme.dart          # App theming
```

## Key Features

### Dashboard
- Personalized greeting based on time of day
- Total payments display
- Today's payments status
- Remaining monthly budget calculation
- Quick access to upcoming payments

### Payment Management
- Add new payments with description, amount, and day
- Edit existing payments
- Delete payments with confirmation
- View all payments sorted by day

### Security
- PIN-based authentication
- Biometric authentication (when available)
- Secure storage for sensitive data
- Local-only data storage

## Development

### Adding New Features
1. Create new screens in appropriate directories
2. Update providers for state management
3. Add database operations if needed
4. Update navigation as required

### Testing
- Test on both Android and iOS devices
- Verify offline functionality
- Test authentication flows
- Validate data persistence

## License

This project is created as a mobile version of the uBillz web application.
