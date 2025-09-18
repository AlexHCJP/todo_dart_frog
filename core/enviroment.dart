class Enviroment {
  static const String databaseHost = String.fromEnvironment(
    'DATABASE_HOST',
    defaultValue: 'localhost',
  );
  static const int databasePort = int.fromEnvironment(
    'DATABASE_PORT',
    defaultValue: 5432,
  );
  static const String databaseName = String.fromEnvironment(
    'DATABASE_NAME',
    defaultValue: 'todo',
  );
  static const String databaseUsername = String.fromEnvironment(
    'DATABASE_USERNAME',
    defaultValue: 'postgres',
  );
  static const String databasePassword = String.fromEnvironment(
    'DATABASE_PASSWORD',
    defaultValue: 'password',
  );
  static const String secretKey = String.fromEnvironment(
    'SECRET_KEY',
    defaultValue: 'your_secret_key',
  );
}