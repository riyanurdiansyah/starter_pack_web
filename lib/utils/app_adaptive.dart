import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoActivityIndicator(radius: 20) // iOS
        : const CircularProgressIndicator(); // Android & Web
  }
}
