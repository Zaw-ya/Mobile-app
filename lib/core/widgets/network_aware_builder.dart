import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'connection_banner_wrapper.dart';

class NetworkAwareBuilder extends StatelessWidget {
  final Widget myChild;

  const NetworkAwareBuilder({super.key, required this.myChild});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
          ) {
        final bool isConnected =
        !connectivity.contains(ConnectivityResult.none);

        return ConnectionBannerWrapper(
          isConnected: isConnected,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: myChild,
          ),
        );
      },
      child: myChild,
    );
  }
}