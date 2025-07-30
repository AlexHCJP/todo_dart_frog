import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_request_logger/dart_frog_request_logger.dart';
import 'package:dart_frog_request_logger/log_formatters.dart';

import '../data_source/todo_datasource.dart';

final requustLogger = provider<RequestLogger>(
  (context) => RequestLogger(
    headers: context.request.headers,
    logFormatter: formatSimpleLog(),
  ),
);

final todosource = TodoDatasource();

Handler middleware(Handler handler) {
  return handler.use(requestLogger())
    .use(requustLogger)
    .use(provider<TodoDatasource>((_) => todosource));
}
