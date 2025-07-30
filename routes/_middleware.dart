import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_request_logger/dart_frog_request_logger.dart';
import 'package:dart_frog_request_logger/log_formatters.dart';

import '../data_source/todo_datasource.dart';

Middleware requustLogger2() => provider<RequestLogger>(
  (context) => RequestLogger(
    headers: context.request.headers,
    logFormatter: formatSimpleLog(),
  ),
);


final TodoDatasource todoDatasource = TodoDatasource();

Middleware todoprovider() => provider<TodoDatasource>(
  (context) => todoDatasource
);



Handler middleware(Handler handler) {
  return handler.use(requestLogger())
    .use(requustLogger2())
    .use(todoprovider());
}
