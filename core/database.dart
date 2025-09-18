import 'package:postgres/postgres.dart';

import 'enviroment.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> get instance async =>
      _connection ?? await getConnection();

  static Future<Connection> getConnection() async {
    return _connection = await Connection.open(
      Endpoint(
        host: Enviroment.databaseHost,
        database: Enviroment.databaseName,
        username: Enviroment.databaseUsername,
        password: Enviroment.databasePassword,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }
}
