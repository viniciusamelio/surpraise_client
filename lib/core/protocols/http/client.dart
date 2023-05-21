import 'response.dart';

typedef RequestProgress = void Function(int count, int total);
typedef QueryParams = Map<String, dynamic>;

abstract class HttpClient {
  void updateBaseUrl(String baseUrl);
  void addHeaders(Map<String, String> map);
  void addHeader(Map<String, dynamic> header);

  Future<HttpResponse<T>> get<T>(
    String url, {
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  });

  Future<HttpResponse<T>> getBytes<T>(
    String url, {
    String? contentType,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
    HttpClientResponseType type = HttpClientResponseType.bytes,
  });

  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  });

  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  });

  Future<HttpResponse<T>> patch<T>(
    String url, {
    dynamic data,
    QueryParams? queryParameters,
    RequestProgress? onReceiveProgress,
  });

  Future<HttpResponse<T>> delete<T>(
    String url, {
    dynamic data,
    QueryParams? queryParameters,
  });
}
