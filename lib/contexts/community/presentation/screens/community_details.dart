import 'package:flutter/material.dart';

class CommunityDetailsScreen extends StatefulWidget {
  const CommunityDetailsScreen({super.key});
  static const String routeName = "/community";

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  late final String communityId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    communityId = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
