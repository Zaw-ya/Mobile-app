import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/services/bootstrap.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';
import 'core/di/dependency_injection.dart';

void main() {
  bootstrap(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    String deviceLanguage = Platform.localeName.split('_')[0];
    Locale initialLocale = const Locale('ar');
    if (deviceLanguage == 'ar' || deviceLanguage == 'en') {
      initialLocale = Locale(deviceLanguage);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EventCalenderCubit>()),
        //BlocProvider(create: (context) => getIt<HomeCubit>()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        saveLocale: true,
        startLocale: initialLocale,
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        child: const MyInvite(),
      ),
    );
  }
}

