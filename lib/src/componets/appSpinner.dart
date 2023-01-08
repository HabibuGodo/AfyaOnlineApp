import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../theme/app_theme.dart';

class AppSpinner extends StatelessWidget {
  const AppSpinner({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitPulse(
            color: AppTheme.communityTBTheme.primaryColor,
            size: 80,
          ),
        ));
  }
}
