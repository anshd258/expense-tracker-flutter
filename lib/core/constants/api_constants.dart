class ApiConstants {
  static const String authLogin = '/auth/token';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';

  static const String expenses = '/expenses/';
  static const String expensesById = '/expenses/{id}';

  static const String reports = '/reports/';
  static const String reportsDaily = '/reports/daily';
  static const String reportsWeekly = '/reports/weekly';
  static const String reportsMonthly = '/reports/monthly';
  static const String reportsExportCsv = '/reports/export/csv';

  static const String aiPredictCategory = '/ai/predict-category';
}
