import 'package:blurple/widgets/tab/tab.dart';
import 'package:blurple/widgets/tab/tab_item.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = "/profile";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;
  late final SessionController sessionController;

  @override
  void initState() {
    sessionController = injected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(activeIndex: 1, onTap: (index) {}),
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderOrganism(
              user: sessionController.currentUser!,
            ),
            const SizedBox(
              height: 20,
            ),
            const BlurpleTabBar(
              items: [
                DefaultTabItem(
                  isActive: true,
                  child: Text("Meus praises"),
                ),
                DefaultTabItem(
                  isActive: false,
                  child: Text("Comunidades"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
