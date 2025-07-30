import 'package:postgres/postgres.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> get instance async =>
      _connection ?? await getConnection();

  static Future<Connection> getConnection() async {
    return _connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'mydb',
        username: 'alexsandrbangert',
        password: '',
      
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.disable
      )
    );
  }
}
