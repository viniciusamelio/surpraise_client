import 'dart:convert';

class HttpResponse<T> {
  final T? data;
  final int? statusCode;
  final dynamic headers;

  const HttpResponse({
    this.data,
    this.headers,
    this.statusCode,
  });

  @override
  String toString() {
    if (data is Map) return json.encode(data);
    return data.toString();
  }
}

enum HttpClientResponseType { json, stream, plain, bytes }
