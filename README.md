# Expense Tracker - Flutter Frontend

A comprehensive personal finance management application built with Flutter that helps users track their daily expenses, categorize spending, and gain insights into their financial habits through intelligent features and visual analytics.

## Purpose

This expense tracker is designed to simplify personal financial management by providing:
- **Effortless Expense Recording**: Quick and intuitive expense entry with smart categorization
- **Financial Insights**: Clear visualization of spending patterns and trends
- **Budget Awareness**: Understanding where your money goes to make informed financial decisions
- **Secure Data Management**: Protected user data with robust authentication

## Key Features

### 🔐 **Secure Authentication**
- JWT-based authentication system
- Secure token storage using flutter_secure_storage
- User registration and login with session management
- Auto-refresh token logic for seamless user experience

### 💰 **Smart Expense Management**
- **Quick Entry**: Add expenses with amount, description, category, and date
- **CRUD Operations**: Full create, read, update, delete functionality
- **Smart Categorization**: AI-powered category suggestions based on expense descriptions
- **Filtering & Search**: Find expenses quickly with advanced filtering options
- **Pull-to-Refresh**: Real-time data synchronization

### 🤖 **AI-Powered Features**
- **Category Prediction**: Automatic category suggestions using machine learning
- **High Confidence Auto-fill**: Categories with >70% confidence are automatically selected
- **Learning System**: Improves accuracy based on user patterns

### 📊 **Analytics & Reporting** (Coming Soon)
- Daily, weekly, and monthly spending summaries
- Visual charts and graphs using fl_chart
- Spending category breakdowns
- Trend analysis and insights

### 🎨 **Modern User Experience**
- Clean, intuitive interface built with shadcn_ui
- Responsive design for all screen sizes
- Consistent design language
- Smooth animations and transitions

## Architecture

### 🏗️ **Clean Architecture Pattern**
The application follows clean architecture principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │     Widgets     │  │     Screens     │  │     BLoC     │ │
│  │   (UI Layer)    │  │  (Page Layer)   │  │ (State Mgmt) │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │     Models      │  │   Use Cases     │  │ Repositories │ │
│  │ (Data Entities) │  │ (Business Logic)│  │ (Interfaces) │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   API Services  │  │ Local Storage   │  │   Providers  │ │
│  │ (Remote Data)   │  │ (Cache/Tokens)  │  │(Data Sources)│ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 🧱 **State Management - BLoC Pattern**
- **AuthBloc**: Manages authentication state, login/logout flows
- **ExpenseBloc**: Handles expense CRUD operations and state
- **ReportBloc**: Manages analytics and reporting (planned)
- **Event-Driven**: Reactive programming with clear event/state flow

### 🌐 **API Integration Architecture**
- **Dio HTTP Client**: Robust HTTP client with interceptors
- **Token Management**: Automatic JWT token attachment and refresh
- **Error Handling**: Centralized error handling and user feedback
- **Offline Support**: Local caching for improved user experience (planned)

### 📱 **Tech Stack**

**Frontend Framework**
- **Flutter 3.x**: Cross-platform mobile development
- **Dart**: Programming language

**State Management**
- **flutter_bloc**: Predictable state management with BLoC pattern
- **Provider**: Dependency injection and state sharing

**UI & Design**
- **shadcn_ui**: Modern, consistent UI component library
- **fl_chart**: Data visualization and charting
- **Material Design 3**: Google's latest design system

**Data & Storage**
- **Dio**: HTTP client for API communication
- **flutter_secure_storage**: Secure local storage for tokens
- **json_serializable**: Automatic JSON serialization/deserialization

**Development Tools**
- **build_runner**: Code generation
- **freezed**: Immutable classes and unions (planned)
- **injectable**: Dependency injection (planned)

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
