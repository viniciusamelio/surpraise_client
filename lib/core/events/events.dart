import 'dart:async';

abstract class ApplicationEvent<T> {
  const ApplicationEvent(this.data);
  final T data;
}

abstract class ApplicationEventBus {
  void on<T extends ApplicationEvent>(void Function(T event) handler,
      {String? name});
  void add<T extends ApplicationEvent>(T event);
  void removeListener(String name);
}

class DefaultBus implements ApplicationEventBus {
  final _stream = StreamController<ApplicationEvent>.broadcast();
  final Map<String, StreamSubscription> _subs = {};

  @override
  void add<T extends ApplicationEvent>(T event, {String? name}) {
    _stream.add(event);
  }

  @override
  void on<T extends ApplicationEvent>(
    void Function(T event) handler, {
    String? name,
  }) {
    final sub = _stream.stream
        .where((event) => event is T)
        .listen((value) => handler(value as T));

    if (name == null) return;

    _subs[name] = sub;
  }

  @override
  void removeListener(String name) {
    final sub = _subs[name];
    sub?.cancel();
    _subs.remove(name);
  }
}
