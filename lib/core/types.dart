import 'package:ez_either/ez_either.dart';

typedef AsyncAction<R> = Future<Either<Exception, R>>;
typedef Json = Map<String, dynamic>;
