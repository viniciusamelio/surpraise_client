import 'package:blurple/sizes/radius.dart';
import 'package:blurple/sizes/spacings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/state/default_state.dart';
import '../../../../shared/presentation/molecules/error_widget.dart';
import '../../../../shared/presentation/molecules/loader.dart';
import '../../dtos.dart';
import '../controllers/notifications.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsController controller;

  @override
  void initState() {
    controller = injected();
    controller.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = EdgeInsets.all(
      Spacings.lg,
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: screenPadding,
      child: PolymorphicAtomObserver<DefaultState<Exception, Notifications>>(
        atom: controller.state,
        types: [
          TypedAtomHandler(
            type: LoadingState<Exception, Notifications>,
            builder: (context, state) {
              return const LoaderMolecule();
            },
          ),
          TypedAtomHandler(
            type: ErrorState<Exception, Notifications>,
            builder: (context, state) {
              return const ErrorWidgetMolecule(
                message: "Deu ruim ao recuperar suas notificações",
              );
            },
          ),
        ],
        defaultBuilder: (value) {
          final Notifications data = (value as SuccessState).data;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => NotificationTileMolecule(
                notification: data[index],
              ),
              separatorBuilder: (_, __) => SizedBox(
                height: Spacings.md,
              ),
              itemCount: data.length,
            ),
          );
        },
      ),
    );
  }
}

class NotificationTileMolecule extends StatelessWidget {
  const NotificationTileMolecule({super.key, required this.notification});

  final NotificationDto notification;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.elevatedWidgetsColor,
        borderRadius: BorderRadius.circular(
          RadiusTokens.md,
        ),
        border: Border.all(
          color: notification.viewed
              ? Colors.transparent
              : theme.colorScheme.accentColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${notification.message} 😁",
            style: theme.fontScheme.p1.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: Spacings.xs,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  notification.topic,
                  style: theme.fontScheme.p1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMd("pt-BR").format(
                    notification.sentAt,
                  ),
                  style: theme.fontScheme.p1,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
