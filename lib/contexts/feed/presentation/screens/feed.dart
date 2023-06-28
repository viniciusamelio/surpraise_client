import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../shared/presentation/controllers/session.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  static const String routeName = '/feed/';
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    injected<SessionController>().logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
