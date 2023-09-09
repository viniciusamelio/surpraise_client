import 'package:blurple/sizes/spacings.dart';
import 'package:flutter/material.dart';
import '../../../../core/external_dependencies.dart';
import '../../feed.dart';
import '../molecules/molecules.dart';
import '../../../../core/core.dart';

import '../../../../shared/shared.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  static const String routeName = '/feed/';
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final SessionController sessionController;
  late final FeedController controller;

  @override
  void initState() {
    sessionController = injected();
    controller = injected();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final user = ModalRoute.of(context)!.settings.arguments;
    sessionController.currentUser = user! as UserDto;
    if (controller.state.value is InitialState) {
      controller.getPraises(sessionController.currentUser!.id);
      controller.getInvites(sessionController.currentUser!.id);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(
              Spacings.lg,
            ),
            child: Column(
              children: [
                UserDisplayer(
                  user: sessionController.currentUser!,
                ),
                SizedBox(
                  height: Spacings.lg,
                ),
                Text.rich(
                  TextSpan(
                    text: "Aqui você consegue ver os ",
                    style: context.theme.fontScheme.p2.copyWith(fontSize: 16),
                    children: [
                      TextSpan(
                        text: "#praises ",
                        style: context.theme.fontScheme.p2.copyWith(
                          fontSize: 16,
                          color: context.theme.colorScheme.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            style: context.theme.fontScheme.p2
                                .copyWith(fontSize: 16),
                            text:
                                "recentes.\nQue tal mandar um pra aquele parça que sempre te ajuda no trampo? ",
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Spacings.lg,
                ),
                AtomObserver<DefaultState>(
                  atom: controller.state,
                  builder: (context, state) {
                    if (state is LoadingState || state is InitialState) {
                      return const CircularProgressIndicator();
                    } else if (state is ErrorState) {
                      return const Text("error");
                    }

                    final List<PraiseDto> data = (state as SuccessState).data;

                    if (data.isEmpty) {
                      return Column(
                        children: [
                          LottieBuilder.asset(
                            "assets/animations/empty-state.json",
                            height: 280,
                          ),
                          Text(
                            "Parece que você não tem novos #praises por aqui, que tal começar enviando um?! É só apertar o botão abaixo",
                            style: context.theme.fontScheme.p2.copyWith(
                              fontSize: 18,
                              color: context.theme.colorScheme.foregroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                      height: (300 * data.length).toDouble(),
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) =>
                            Text(data[index].message),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: MediaQuery.of(context).size.height / 2 - 160,
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(8)),
                    color: context.theme.colorScheme.elevatedWidgetsColor),
                child: Icon(
                  Icons.filter_alt_outlined,
                  size: 24,
                  color: context.theme.colorScheme.accentColor.withAlpha(200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
