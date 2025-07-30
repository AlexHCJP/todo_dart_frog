import 'dart:io';

import 'package:postgres/postgres.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> get instance async =>
      _connection ?? await getConnection();

  static Future<Connection> getConnection() async {
    return _connection = await Connection.open(
      Endpoint(
        host: Platform.environment['DATABASE_HOST']!,
        database: Platform.environment['DATABASE_NAME']!,
        username: Platform.environment['DATABASE_USERNAME'],
        password: Platform.environment['DATABASE_PASSWORD'],
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }
}
