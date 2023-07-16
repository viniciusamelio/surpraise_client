import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/tokens/color_tokens.dart';
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
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    sessionController = injected();
    controller = injected();
    controller.getCommunities(sessionController.currentUser!.id);
    controller.getPraises(sessionController.currentUser!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(activeIndex: 1, onTap: (index) {}),
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: Column(
        children: [
          ProfileHeaderOrganism(
            user: sessionController.currentUser!,
          ),
          const SizedBox(
            height: 20,
          ),
          BlurpleTabBar(
            onChangeActive: (index) => pageController.jumpToPage(index),
            items: const [
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
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                ValueListenableBuilder(
                  valueListenable: controller.state,
                  builder: (context, state, _) {
                    if (state is LoadingState) {
                      return const CircularProgressIndicator();
                    }

                    final List<PraiseDto> data = (state as SuccessState).data;
                    return SizedBox(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(Spacings.lg),
                            decoration: BoxDecoration(
                              color: ColorTokens.concrete,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: controller.communitiesState,
                  builder: (context, state, _) {
                    if (state is LoadingState) {
                      return const CircularProgressIndicator();
                    }

                    final List<FindCommunityOutput> data =
                        (state as SuccessState).data;
                    return SizedBox(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(Spacings.lg),
                            decoration: BoxDecoration(
                              color: ColorTokens.concrete,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
