# Expense Tracker - Flutter Frontend

A modern mobile expense tracking application built with Flutter, featuring authentication, expense management, AI-powered category suggestions, and comprehensive reporting.

## Features

- 🔐 **Authentication**: Secure JWT-based authentication with login/register functionality
- 💰 **Expense Management**: Full CRUD operations for expenses
- 📊 **Reports & Charts**: Visual analytics with daily/weekly/monthly summaries (coming soon)
- 🎨 **Modern UI**: Built with shadcn_ui for a clean, consistent design
- 📱 **Responsive Design**: Works seamlessly across different screen sizes

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC (flutter_bloc)
- **UI Components**: shadcn_ui
- **HTTP Client**: Dio with interceptors
- **Charts**: fl_chart (ready for implementation)
- **Local Storage**: flutter_secure_storage for JWT tokens
- **Serialization**: json_serializable

## Prerequisites

- Flutter SDK (3.x or higher)
- Dart SDK

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd newsurge_frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

1. Run the Flutter app:
```bash
flutter run
```

For specific platforms:
- iOS: `flutter run -d ios`
- Android: `flutter run -d android`
- Web: `flutter run -d chrome`

## Project Structure

```
lib/
├── core/
│   ├── constants/      # API endpoints and app constants
│   └── theme/          # App theme configuration
├── features/
│   ├── auth/           # Authentication feature
│   ├── expenses/       # Expense management
│   ├── reports/        # Reports and analytics
│   ├── charts/         # Data visualization
│   └── ai_suggestion/  # AI category prediction
├── models/             # Data models
├── services/           # API services
├── providers/          # State providers
└── widgets/            # Shared widgets
```

## Key Features Implementation

### Authentication Flow
- JWT token storage using flutter_secure_storage
- Auto-refresh token logic
- Protected routes for authenticated users

### Expense Management
- Add expenses with amount, description, category, and date
- View expense list with filtering options
- Edit and delete expenses
- Pull-to-refresh functionality

### AI Category Suggestion
- Automatically suggests category based on expense description
- High confidence predictions (>70%) auto-fill the category dropdown
- Seamless integration with the add expense flow

## API Integration

The app integrates with the FastAPI backend endpoints:
- `/auth/login` - User login
- `/auth/register` - User registration
- `/expenses` - CRUD operations for expenses
- `/reports/*` - Various report endpoints
- `/ai/predict-category` - AI category prediction

## State Management

Using BLoC pattern for:
- `AuthBloc` - Manages authentication state
- `ExpenseBloc` - Handles expense operations
- `ReportBloc` - Manages report generation (to be implemented)

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Testing

Run tests:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.
