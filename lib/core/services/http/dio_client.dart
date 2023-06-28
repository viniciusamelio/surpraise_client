import 'package:dio/dio.dart';

import '../../protocols/protocols.dart';

class DioClient implements HttpClient {
  final Dio dio;
  const DioClient({required this.dio});

  factory DioClient.defaultClient(Dio dio, [Interceptor? interceptor]) {
    final client = DioClient(dio: dio);

    if (interceptor != null) {
      client.addInterceptor(interceptor);
    }

    return client;
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  @override
  void updateBaseUrl(String baseUrl) {
    dio.options = dio.options.copyWith(baseUrl: baseUrl);
  }

  @override
  void addHeader(Map<String, dynamic> header) {
    final headers = dio.options.headers;
    dio.options = dio.options.copyWith(headers: headers..addAll(header));
  }

  @override
  void addHeaders(Map<String, String> map) {
    dio.options.headers.addAll(map);
  }

  ResponseType parseDioResponseType(HttpClientResponseType type) {
    return ResponseType.values.firstWhere(
      orElse: () => ResponseType.bytes,
      (it) => it.name.compareTo(type.name) == 0,
    );
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String url, {
    CancelToken? cancelToken,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  }) async {
    final response = await dio.get<T>(
      url,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );

    return HttpResponse(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse<T>> getBytes<T>(
    String url, {
    String? contentType,
    CancelToken? cancelToken,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
    HttpClientResponseType type = HttpClientResponseType.bytes,
  }) async {
    final response = await dio.get<T>(
      url,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      options: Options(
        contentType: contentType,
        responseType: parseDioResponseType(type),
      ),
    );

    return HttpResponse(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  }) async {
    final response = await dio.post<T>(
      url,
      data: data,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );

    return HttpResponse<T>(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  }) async {
    final response = await dio.put<T>(
      url,
      data: data,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );

    return HttpResponse(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse<T>> patch<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  }) async {
    final response = await dio.patch<T>(
      url,
      data: data,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );

    return HttpResponse(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    QueryParams? queryParameters,
  }) async {
    final response = await dio.delete<T>(
      url,
      data: data,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );

    return HttpResponse(
      data: response.data,
      headers: response.headers.map,
      statusCode: response.statusCode,
    );
  }
}
