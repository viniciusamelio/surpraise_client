import 'package:blurple/sizes/spacings.dart';
import 'package:flutter/material.dart';
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
    if (controller.state is InitialState) {
      controller.getPraises(sessionController.currentUser!.id);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: Navbar(
        activeIndex: 0,
        onTap: (index) {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  text: "Aqui você consegue ver ",
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
                              "os recentes.\nQue tal mandar um pra aquele parça que sempre te ajuda no trampo? ",
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Spacings.lg,
              ),
              ValueListenableBuilder<DefaultState>(
                valueListenable: controller.state,
                builder: (context, state, __) {
                  if (state is LoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is ErrorState) {
                    return const Text("error");
                  }

                  final List<PraiseDto> data = (state as SuccessState).data;

                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        "Parece que você não tem novos #praises por aqui, que tal começar enviando um?!",
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Text(data[index].message),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
