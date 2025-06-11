import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class ProfileViewModel {
  final enableDeveloperMode = signal(false);

  Future<void> initSignals() async {
    enableDeveloperMode.value = await SharedPreferenceUtil.getDeveloperMode();
  }

  Future<void> navigateAboutPage(BuildContext context) async {
    var developerModel = await AboutRoute().push<bool>(context);
    if (developerModel == true) {
      enableDeveloperMode.value = true;
      await SharedPreferenceUtil.setDeveloperMode(true);
    }
  }

  Future<void> navigateDeveloperPage(BuildContext context) async {
    var developerModel = await DeveloperRoute().push<bool>(context);
    if (developerModel == false) {
      enableDeveloperMode.value = false;
      await SharedPreferenceUtil.setDeveloperMode(false);
    }
  }
}
