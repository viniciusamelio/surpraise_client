import 'package:ez_either/ez_either.dart';
import 'package:flutter/material.dart';

typedef AsyncAction<R> = Future<Either<Exception, R>>;
typedef Json = Map<String, dynamic>;
typedef FormKey = GlobalKey<FormState>;
