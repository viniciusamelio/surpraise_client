import 'package:kiwi/kiwi.dart';

typedef InstanceBuilder<T> = T Function();

void _injectFactory<T>(InstanceBuilder<T> builder, [String? name]) {
  KiwiContainer().registerFactory<T>(
    (_) => builder(),
  );
}

void _injectSingleton<T>(InstanceBuilder<T> builder, [String? name]) {
  KiwiContainer().registerSingleton<T>((container) => builder());
}

void inject<T>(T instance, {bool? singleton, String? name}) => singleton == true
    ? _injectSingleton(() => instance, name)
    : _injectFactory(() => instance, name);

T injected<T>([String? name]) => KiwiContainer().call<T>(name);
